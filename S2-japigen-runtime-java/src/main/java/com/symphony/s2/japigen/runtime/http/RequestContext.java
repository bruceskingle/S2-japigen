/*
 *
 *
 * Copyright 2018 Symphony Communication Services, LLC.
 *
 * Licensed to The Symphony Software Foundation (SSF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package com.symphony.s2.japigen.runtime.http;

import java.io.IOException;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;

public class RequestContext
{
  private static final String JSON_CONTENT_TYPE = "application/json";

  private static Logger log_ = LoggerFactory.getLogger(RequestContext.class);
  
  private HttpServletRequest  request_;
  private HttpServletResponse response_;
  private Map<String, Cookie> cookieMap_;
  private Map<String, String> pathMap_;
  private List<String>        errors_ = new LinkedList<>();

  public RequestContext(HttpServletRequest request, HttpServletResponse response)
  {
    request_ = request;
    response_ = response;
  }

  public Long  getParameterAsLong(String name, ParameterLocation location, boolean required)
  {
    String s = getParameterAsString(name, location, required);
    
    if(s == null)
      return null;
    
    try
    {
      return Long.parseLong(s);
    }
    catch(NumberFormatException e)
    {
      errors_.add(String.format("Long %s parameter \"%s\" is not a valid long value (\"%s\")", location, name, s));
      return null;
    }
  }

  public Integer  getParameterAsInteger(String name, ParameterLocation location, boolean required)
  {
    String s = getParameterAsString(name, location, required);
    
    if(s == null)
      return null;
    
    try
    {
      return Integer.parseInt(s);
    }
    catch(NumberFormatException e)
    {
      errors_.add(String.format("Integer %s parameter \"%s\" is not a valid int value (\"%s\")", location, name, s));
      return null;
    }
  }

  public String  getParameterAsString(String name, ParameterLocation location, boolean required)
  {
    String  value = null;
    
    switch(location)
    {
      case Cookie:
        if(cookieMap_ == null)
        {
          cookieMap_ = new HashMap<>();
          
          for(Cookie cookie : request_.getCookies())
            cookieMap_.put(cookie.getName(), cookie);
        }
        value = cookieMap_.get(name).getValue();
        break;
        
      case Header:
        value = request_.getHeader(name);
        break;
        
      case Path:
        if(pathMap_ == null)
        {
          pathMap_ = new HashMap<>();
          
          String pathInfo = request_.getPathInfo();
          
          if(pathInfo != null)
          {
            String[] parts = pathInfo.split("/");
            int      i=1;
            
            while(parts.length > i)
            {
              pathMap_.put(parts[i++], parts[i++]);
            }
          }
          value = pathMap_.get(name);
        }
        break;
      
      case Query:
        value = request_.getParameter(name);
        break;
    }
    
    if(value == null && required)
    {
      errors_.add(String.format("Required %s parameter \"%s\" is missing", location, name));
    }
    
    return value;
  }

  public boolean preConditionsAreMet()
  {
    if(errors_.isEmpty())
      return true;
    
    ObjectMapper mapper = new ObjectMapper();
    
    ArrayNode arrayNode = mapper.createArrayNode();
    
    for(String error : errors_)
    {
      arrayNode.add(error);
    }
    
    try
    {
      response_.setContentType(JSON_CONTENT_TYPE);
      response_.setStatus(HttpServletResponse.SC_BAD_REQUEST);
      response_.getWriter().println(arrayNode.toString());
      
    }
    catch (IOException e)
    {
      log_.error("Failed to send error response", e);
    }

    return false;
  }
}
