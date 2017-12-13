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

import org.symphonyoss.s2.japigen.parser.ParserContext;
import org.symphonyoss.s2.japigen.parser.error.ParserError;

import com.fasterxml.jackson.databind.JsonNode;

public class EnumSchema extends ModelElement
{
  private Set<String>   values_ = new HashSet<>();
  
  public EnumSchema(ModelElement parent, ParserContext parserContext)
  {
    super(parent, parserContext, "Enum");
    
    for(JsonNode child : parserContext.getJsonNode())
    {
      if(!values_.add(child.asText()))
      {
        parserContext.raise(new ParserError("Duplicate enum constant \"%s\"", child.asText()));
      }
    }
  }

  public Set<String> getValues()
  {
    return values_;
  }

}
