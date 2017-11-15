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

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.symphonyoss.s2.japigen.JAPIGEN;
import org.symphonyoss.s2.japigen.parser.GenerationContext;
import org.symphonyoss.s2.japigen.parser.GenerationException;
import org.symphonyoss.s2.japigen.parser.ParserContext;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.node.ObjectNode;

public class Model extends ModelElement
{
  private static final String COMPONENTS = "components";

  private static Logger       log_       = LoggerFactory.getLogger(Model.class);

  private Version             openapi_;
  private Map<String, String> modelMap_ = new HashMap<>();
  private SimpleDateFormat    yearFormat_ = new SimpleDateFormat("yyyy");
  private SimpleDateFormat    yearMonthFormat_ = new SimpleDateFormat("yyyy-MM");
  private SimpleDateFormat    dateFormat_ = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss z");

  public Model(ParserContext parserContext)
  {
    super(null, parserContext, "Model");
    
    
    openapi_ = new Version(this, parserContext.get("openapi"));
    add(openapi_);
    
    ParserContext japigen = parserContext.get(JAPIGEN.X_MODEL);
    if(japigen != null)
    {
      JsonNode jsonNode = japigen.getJsonNode();
      
      if(jsonNode instanceof ObjectNode)
      {
        Iterator<Entry<String, JsonNode>> it = jsonNode.fields();
        
        while(it.hasNext())
        {
          Entry<String, JsonNode> entry = it.next();
          
          modelMap_.put(entry.getKey(), entry.getValue().asText());
        }
      }
    }
    
    Date now = new Date();
    
    modelMap_.put(JAPIGEN.YEAR, yearFormat_.format(now));
    modelMap_.put(JAPIGEN.YEAR_MONTH, yearMonthFormat_.format(now));
    modelMap_.put(JAPIGEN.DATE, dateFormat_.format(now));
    
    add(COMPONENTS, new Components(this, parserContext.get(COMPONENTS)));
  }
  
  @Override
  public Model getModel()
  {
    return this;
  }

  public Version getOpenapi()
  {
    return openapi_;
  }

  public Map<String, String> getModelMap()
  {
    return modelMap_;
  }

  public void generate(GenerationContext generationContext) throws GenerationException
  {
    if(getContext().getRootParserContext().hasErrors())
    {
      getContext().error("Code generation aborted due to model validation errors");
    }
    else
    {
      Map<String, Object> dataModel = new HashMap<>();
      
      dataModel.putAll(generationContext.getDataModel());
      dataModel.putAll(modelMap_);
      
      generate(generationContext, dataModel);
    }
  }
}
