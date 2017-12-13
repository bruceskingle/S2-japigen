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

import org.symphonyoss.s2.japigen.JAPIGEN;
import org.symphonyoss.s2.japigen.parser.ParserContext;
import org.symphonyoss.s2.japigen.parser.error.ParserError;

public abstract class Type extends Schema
{
  private EnumSchema enum_;

  public Type(ModelElement parent, ParserContext context, String type)
  {
    super(parent, context, type);
    
    ParserContext enumNode = getContext().get(JAPIGEN.ENUM);
    
    if(enumNode != null)
    {
      if(!isEnumAllowed())
      {
        getContext().raise(new ParserError("%s is not suported on this type.", JAPIGEN.ENUM));
      }
      else if(enumNode.getJsonNode().isArray())
      {
        enum_ = new EnumSchema(this, enumNode);
        add(enum_);
      }
      else
      {
        getContext().raise(new ParserError("%s must be an array", JAPIGEN.ENUM));
      }
    }
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
        context.raise(new ParserError("Type \"%s\" is of unknown type \"%s\"", context.getName(), node.getJsonNode().asText()));
    }

    return null;
  }
  
  public boolean isEnumAllowed()
  {
    // Overridden in StringType
    return false;
  }

  public EnumSchema getEnum()
  {
    return enum_;
  }

  @Override
  public boolean getHasSet()
  {
    return enum_ != null || super.getHasSet();
  }
}
