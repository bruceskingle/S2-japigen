/*
 *
 *
 * Copyright 2017 Symphony Communication Services, LLC.
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

package org.symphonyoss.s2.japigen.model;

import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.symphonyoss.s2.japigen.parser.ParserContext;

public class Model
{
  private static final String COMPONENTS = "components";
  private static final String SCHEMAS = "schemas";

  private static Logger log_ = LoggerFactory.getLogger(Model.class);
  
  private ParserContext parserContext_;
  private Version openapi_;
  private Map<String, ObjectOrReferenceSchema> schemaMap_ = new HashMap<>();

  public Model(ParserContext parserContext)
  {
    parserContext_ = parserContext;
    openapi_ = new Version(parserContext.getJsonNode().get("openapi").asText());
      
    parseComponents(parserContext.get(COMPONENTS));
  }

  private void parseComponents(ParserContext components)
  {
    parseSchemas(components.get(SCHEMAS));
  }

  private void parseSchemas(ParserContext schemas)
  {
    for(ParserContext schema : schemas)
      parseSchema(schema);
  }
  
  private void parseSchema(ParserContext schema)
  {
     log_.debug("Found schema \"" + schema.getName() + "\" at " + schema.getPath());
     
     Schema objectSchema = Field.createSchema(this, schema);
     
     if(objectSchema instanceof ObjectOrReferenceSchema)
       schemaMap_.put(schema.getPath(), (ObjectOrReferenceSchema) objectSchema);
     else
       schema.error("Expected an Object Schema but found " + objectSchema);
  }

}
