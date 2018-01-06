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

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.symphonyoss.s2.japigen.parser.ParserContext;
import org.symphonyoss.s2.japigen.parser.error.ParserError;

public abstract class ParameterContainer extends ModelElement
{
  private static Logger log_ = LoggerFactory.getLogger(ParameterContainer.class);

  private Map<ParameterLocation, Map<String, OpenApiParameter>> parameters_ = new HashMap<>();
  
  public ParameterContainer(ModelElement parent, ParserContext parserContext, String type, String name)
  {
    super(parent, parserContext, type, name);
    
    for(ParameterLocation l : ParameterLocation.values())
      parameters_.put(l, new HashMap<>());
    
    ParserContext listContext = parserContext.get("parameters");
    
    if(listContext != null)
    {
      if(!listContext.getJsonNode().isArray())
      {
        parserContext.raise(new ParserError("The \"parameters\" node must be an array."));
        return;
      }
      
      for(ParserContext paramContext : listContext)
      {
        OpenApiParameter param = OpenApiParameter.create(this, paramContext);
        
        if(param != null)
        {
          add(param);
          Map<String, OpenApiParameter> map = parameters_.get(param.getLocation());
          
          if((parent instanceof ParameterContainer && ((ParameterContainer)parent).hasParameter(param))
              || map.containsKey(param.getName()))
          {
            parserContext.raise(new ParserError("Duplicate parameter \"%s\" in %s", param.getName(), param.getLocation()));
          }
          else
          {
            map.put(param.getName(), param);
          }
        }
      }
    }
  }

  private boolean hasParameter(OpenApiParameter param)
  {
    return parameters_.get(param.getLocation()).containsKey(param.getName());
  }

  public Map<ParameterLocation, Map<String, OpenApiParameter>> getParameters()
  {
    return parameters_;
  }
  
  public Map<String, OpenApiParameter>  getPathParameters()
  {
    return parameters_.get(ParameterLocation.Path);
  }
  
  public Map<String, OpenApiParameter>  getCookieParameters()
  {
    return parameters_.get(ParameterLocation.Cookie);
  }
  
  public Map<String, OpenApiParameter>  getHeaderParameters()
  {
    return parameters_.get(ParameterLocation.Header);
  }
  
  public Map<String, OpenApiParameter>  getQueryParameters()
  {
    return parameters_.get(ParameterLocation.Query);
  }
  
  @Override
  public void getReferencedTypes(Set<AbstractSchema> result)
  {
    super.getReferencedTypes(result);
    
    for(Map<String, OpenApiParameter> map : parameters_.values())
      for(OpenApiParameter param : map.values())
        param.getReferencedTypes(result);
  }
}
