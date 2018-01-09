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

import java.util.ArrayList;
import java.util.EnumSet;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.symphonyoss.s2.japigen.Japigen;
import org.symphonyoss.s2.japigen.parser.ParserContext;
import org.symphonyoss.s2.japigen.parser.error.ParserError;

public class PathItem extends ParameterContainer
{
  private static Logger         log_        = LoggerFactory.getLogger(PathItem.class);

  private final Set<String>     pathParamNames_;
  private final String          bindPath_;
  private final String          path_;
  private final List<Operation> operations_ = new ArrayList<>();
  private final Set<HttpMethod> unsupportedOperations_ = EnumSet.allOf(HttpMethod.class);
  
  public PathItem(Paths parent, ParserContext parserContext, String name, Set<String> pathParams, String bindPath, String path)
  {
    super(parent, parserContext, "Path", name);
    
    pathParamNames_ = pathParams;
    bindPath_ = bindPath;
    path_ = path;
    
    for(HttpMethod method : HttpMethod.values())
      addMethod(method, parserContext);
  }   


  public static PathItem create(Paths paths, ParserContext parserContext)
  {
    Set<String>  pathParams = new HashSet<>();
    StringBuffer lineBuf = new StringBuffer();
    StringBuffer paramBuf = new StringBuffer();
    StringBuffer bindBuf = new StringBuffer();
    StringBuffer nameBuf = new StringBuffer();
    boolean      inParam=false;
    boolean      inWord=false;
    boolean      inBindPath=true;
    
    for(char c : parserContext.getName().toCharArray())
    {
      switch(c)
      {
        case '{':
          inBindPath=false;
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
            if(!pathParams.add(paramBuf.toString()))
            {
              parserContext.raise(new ParserError("Duplicate path parameter \"%s\"", paramBuf.toString()));
            }
          }
          else
          {
            parserContext.raise(new ParserError("Unexpected } in path after \"%s\"", lineBuf));
          }
          break;
        
        case '/':
          inWord = false;
          if(inParam)
          {
            parserContext.raise(new ParserError("Character '%c' is not permitted in a parameter name.", c));
          }
          break;
        
        default:
          if(inParam)
          {
            paramBuf.append(c);
          }
          
          if(inWord)
          {
            nameBuf.append(c);
          }
          else
          {
            nameBuf.append(Character.toUpperCase(c));
            inWord = true;
          }
      }
      
      lineBuf.append(c);
      
      if(inBindPath)
        bindBuf.append(c);
      
    }
    if(inParam)
    {
      parserContext.raise(new ParserError("Un-terminated parameter (missing }) in path after \"%s\"", lineBuf));
    }
    
    if(pathParams.isEmpty())
    {
      log_.debug("No path params");
    }
    else
    {
      for(String p : pathParams)
        log_.debug("Path param \"{}\"", p);
    }
    
    return new PathItem(paths, parserContext, nameBuf.toString(), pathParams, bindBuf.toString(), lineBuf.toString());
  }

  private void addMethod(HttpMethod method, ParserContext parserContext)
  {
    ParserContext methodContext = parserContext.get(method.toString().toLowerCase());
    
    if(methodContext != null)
      addMethod(method, new Operation(this, methodContext));
  }

  private void addMethod(HttpMethod method, Operation operation)
  {
    add(operation);
    operations_.add(operation);
    
    unsupportedOperations_.remove(method);
  }


  public Set<String> getPathParamNames()
  {
    return pathParamNames_;
  }

  public String getBindPath()
  {
    return bindPath_;
  }

  public String getPath()
  {
    return path_;
  }

  public List<Operation> getOperations()
  {
    return operations_;
  }

  public Set<HttpMethod> getUnsupportedOperations()
  {
    return unsupportedOperations_;
  }
  
  @Override
  public void getReferencedTypes(Set<AbstractSchema> result)
  {
    super.getReferencedTypes(result);
    
    for(Operation op : operations_)
      op.getReferencedTypes(result);
  }
}