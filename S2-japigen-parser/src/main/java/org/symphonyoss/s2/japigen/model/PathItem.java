/*
 *
 *
 * Copyright 2017 Symphony Communication Services, LLC.
 *
 * Licensed to The Symphony Software Foundation (SSF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The SSF licenses this file
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

package org.symphonyoss.s2.japigen.model;

import java.util.HashSet;
import java.util.Set;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.symphonyoss.s2.japigen.JAPIGEN;
import org.symphonyoss.s2.japigen.parser.ParserContext;
import org.symphonyoss.s2.japigen.parser.error.ParserError;

public class PathItem extends ModelElement
{
  private static Logger log_ = LoggerFactory.getLogger(PathItem.class);

  private Set<String>  pathParams_ = new HashSet<>();
  //private Map<ParameterI>
  
  public PathItem(Paths parent, ParserContext parserContext)
  {
    super(parent, parserContext, "Path");
    
    StringBuffer lineBuf = new StringBuffer();
    StringBuffer paramBuf = new StringBuffer();
    boolean      inParam=false;
    
    for(char c : getName().toCharArray())
    {
      if(inParam)
        paramBuf.append(c);
      
      switch(c)
      {
        case '{':
          if(inParam)
          {
            parserContext.raise(new ParserError("Unexpected { in path after \"%s\"", lineBuf));
          }
          else
          {
            inParam = true;
            paramBuf = new StringBuffer();
          }
          break;
          
        case '}':
          if(inParam)
          {
            inParam = false;
            if(!pathParams_.add(paramBuf.toString()))
            {
              parserContext.raise(new ParserError("Duplicate path parameter \"%s\"", paramBuf.toString()));
            }
          }
          else
          {
            parserContext.raise(new ParserError("Unexpected } in path after \"%s\"", lineBuf));
          }
          break;
      }
      
      lineBuf.append(c);
    }
    if(inParam)
    {
      parserContext.raise(new ParserError("Un-terminated parameter (missing }) in path after \"%s\"", lineBuf));
    }
    
    addMethod(JAPIGEN.METHOD_GET, parserContext);
    addMethod(JAPIGEN.METHOD_POST, parserContext);
    addMethod(JAPIGEN.METHOD_PUT, parserContext);
    addMethod(JAPIGEN.METHOD_DELETE, parserContext);
    addMethod(JAPIGEN.METHOD_OPTIONS, parserContext);
    addMethod(JAPIGEN.METHOD_HEAD, parserContext);
    addMethod(JAPIGEN.METHOD_PATCH, parserContext);
    addMethod(JAPIGEN.METHOD_TRACE, parserContext);
    
    ParserContext paramsContext = parserContext.get("parameters");
    
    for(ParserContext pc : paramsContext)
    {
      Parameter param = Parameter.create(this, pc);
      
      if(param != null)
      {
        
      }
    }
  }

  private void addMethod(String methodName, ParserContext parserContext)
  {
    ParserContext methodContext = parserContext.get(methodName);
    
    if(methodContext != null)
      add(new Operation(this, methodContext));
  }
}