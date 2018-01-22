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

import com.symphony.s2.japigen.runtime.http.HttpMethod;

public class PathItem extends ParameterContainer
{
  private static Logger         log_        = LoggerFactory.getLogger(PathItem.class);

  private final Set<String>     pathParamNames_;
  private final String          bindPath_;
  private final String          path_;
  private final String          pathFormat_;
  private final List<Operation> operations_ = new ArrayList<>();
  private final Set<HttpMethod> unsupportedOperations_ = EnumSet.allOf(HttpMethod.class);
  private List<String>          partList_;
  
  public PathItem(Paths parent, ParserContext parserContext, String name, Set<String> pathParams,
      List<String> partList, String bindPath, String path, String pathFormat)
  {
    super(parent, parserContext, "Path", name);
    
    pathParamNames_ = pathParams;
    partList_ = partList;
    bindPath_ = bindPath;
    path_ = path;
    pathFormat_ = pathFormat;
    
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
    StringBuffer partBuf = new StringBuffer();
    StringBuffer formatBuf = new StringBuffer();
    boolean      inParam=false;
    boolean      inWord=false;
    boolean      inBindPath=true;
    List<String> partList = new ArrayList<>();
    
    char[] chars = parserContext.getName().toCharArray();
    
    if(chars[0] != '/')
      parserContext.raise(new ParserError("Path must begin with a /"));
    
    lineBuf.append('/');
    partBuf.append('/');
    formatBuf.append('/');
    
    for(int i=1 ; i<chars.length ; i++)
    {
      char c = chars[i];
      
      switch(c)
      {
        case '{':
          inBindPath=false;
          partList.add(partBuf.toString());
          partBuf = new StringBuffer();
          if(inParam)
          {
            parserContext.raise(new ParserError("Unexpected { in path after \"%s\"", lineBuf));
          }
          else 
          {
            if(chars[i-1] != '/')
            {
              parserContext.raise(new ParserError("Unexpected { in path after \"%s\"", lineBuf));
            }
            inParam = true;
            paramBuf = new StringBuffer();
            formatBuf.append("%s");
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
          if(!inWord)
          {
            parserContext.raise(new ParserError("Double / detected in path.", c));
          }
          inWord = false;
          if(inParam)
          {
            parserContext.raise(new ParserError("Character '%c' is not permitted in a parameter name.", c));
          }
          else
          {
            partBuf.append(c);
            formatBuf.append(c);
          }
          break;
        
        default:
          if(chars[i-1] == '}')
          {
            parserContext.raise(new ParserError("Unexpected characters in variable element after \"%s\"", lineBuf));
          }
          if(inParam)
          {
            paramBuf.append(c);
          }
          else
          {
            partBuf.append(c);
            formatBuf.append(c);
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
    if(inWord)
    {
      String part = partBuf.toString();
      
      if(part.length()>0)
        partList.add(part);
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
    
    return new PathItem(paths, parserContext, nameBuf.toString(), pathParams, partList, bindBuf.toString(),
        lineBuf.toString(), formatBuf.toString());
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
  
  public String getPathFormat()
  {
    return pathFormat_;
  }

  public String getAbsolutePath()
  {
    return getModel().getBasePath() + path_;
  }

  public List<Operation> getOperations()
  {
    return operations_;
  }

  public Set<HttpMethod> getUnsupportedOperations()
  {
    return unsupportedOperations_;
  }
  
  public List<String> getPartList()
  {
    return partList_;
  }
  
  public int getPathParamCnt()
  {
    return pathParamNames_.size();
  }

  @Override
  public void getReferencedTypes(Set<AbstractSchema> result)
  {
    super.getReferencedTypes(result);
    
    for(Operation op : operations_)
      op.getReferencedTypes(result);
  }
}