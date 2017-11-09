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

import org.symphonyoss.s2.japigen.parser.ParserContext;

public class Type extends Schema
{
  private final String  format_;
  
  public Type(ModelElement parent, ParserContext context, String type)
  {
    super(parent, context, type);
    format_ = context.getTextNode("format");
  }

  public String getFormat()
  {
    return format_;
  }

  public static AbstractSchema create(ModelElement parent, ParserContext context, ParserContext node)
  {
    switch(node.getJsonNode().asText())
    {
      case "object":
        return new ObjectSchema(parent, context);
        
      case "array":
        return new ArraySchema(parent, context);
        
      case "integer":
        return new IntegerType(parent, context);
        
      case "number":
        return new DoubleType(parent, context);
        
      case "string":
        return new StringType(parent, context);
        
      case "boolean":
        return new BooleanType(parent, context);
        
      default:
        context.error("Type \"%s\" is of unknown type \"%s\"", context.getName(), node.getJsonNode().asText());
    }

    return null;
  }

  @Override
  protected String toString(ValueMap<String, Object> children)
  {
    children.insert("format", format_, null);
    
    return super.toString(children);
  }
}