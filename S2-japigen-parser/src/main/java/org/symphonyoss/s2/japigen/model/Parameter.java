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

import java.util.Set;

import javax.annotation.Nullable;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.symphonyoss.s2.japigen.parser.ParserContext;
import org.symphonyoss.s2.japigen.parser.error.ParserError;
import org.symphonyoss.s2.japigen.parser.error.UnexpectedTypeError;

public class Parameter extends ModelElement
{
  private static Logger           log_ = LoggerFactory.getLogger(Parameter.class);

  private final ParameterLocation location_;
  private final boolean           required_;
  private final ReferenceOrSchema schema_;

  private Parameter(ModelElement parent, ParserContext parserContext, String name, ParameterLocation location)
  {
    super(parent, parserContext, "Parameter", name);
    
    location_ = location;
    required_ = parserContext.get("required").getJsonNode().asBoolean();
    
    ParserContext schema = parserContext.get("schema");
    
    if(schema == null)
    {
      parserContext.raise(new ParserError("Schema is required"));
      schema_ = null;
    }
    else
    {
      log_.debug("Found schema \"" + schema.getName() + "\" at " + schema.getPath());
      
      AbstractSchema objectSchema = Field.createSchema(this, schema, getName());
      
      String n = objectSchema.getName();
      
      if(objectSchema instanceof ReferenceOrSchema)
      {
        schema_ = (ReferenceOrSchema) objectSchema;
        // don't think we need this: 
        //add(schema.getName(), objectSchema);
      }
      else
      {
        schema_ = null;
        schema.raise(new UnexpectedTypeError(ReferenceOrSchema.class, objectSchema));
      }
    }
  }
  
  public @Nullable static Parameter create(ModelElement methodSchema, ParserContext paramContext)
  {
    ParameterLocation parameterIn = null;
  
    String in = paramContext.getText("in");
    
    switch(in)
    {
      case "query":
        parameterIn = ParameterLocation.Query;
        break;
        
      case "header":
        parameterIn = ParameterLocation.Header;
        break;
        
      case "path":
        parameterIn = ParameterLocation.Path;
        break;
        
      case "cookie":
        parameterIn = ParameterLocation.Cookie;
        break;
        
      default:
        paramContext.raise(new ParserError("Invalid value for in \"%s\"", in));
        return null;
    }
    
    String name = paramContext.getText("name");
    
    if(name == null)
    {
      paramContext.raise(new ParserError("Name is required"));
      name = "UNNAMED";
    }
    
    return new Parameter(methodSchema, paramContext, name, parameterIn);
  }

  public ParameterLocation getLocation()
  {
    return location_;
  }

  public boolean getIsRequired()
  {
    return required_;
  }

  public ReferenceOrSchema getSchema()
  {
    return schema_;
  }

  @Override
  public void validate()
  {
    super.validate();
    schema_.validate();
  }
  
  @Override
  public void getReferencedTypes(Set<AbstractSchema> result)
  {
    super.getReferencedTypes(result);
    
    schema_.getReferencedTypes(result);
  }

  @Override
  public String toString()
  {
    return getName() + " [" + location_ + "]";
  }
}
