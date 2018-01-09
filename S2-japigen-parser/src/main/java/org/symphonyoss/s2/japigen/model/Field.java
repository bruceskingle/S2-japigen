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

import org.symphonyoss.s2.japigen.parser.ParserContext;
import org.symphonyoss.s2.japigen.parser.error.ParserError;

public class Field extends AbstractSchema
{
  private final boolean required_;
  private final AbstractSchema    type_;
  
  public Field(ModelElement parent, ParserContext context, AbstractSchema type, boolean required, String name)
  {
    super(parent, context, "Field", name);
    required_ = required;
    type_ = type;
  }

  public boolean isRequired()
  {
    return required_;
  }

  public AbstractSchema getType()
  {
    return type_;
  }

  @Override
  public boolean getHasSet()
  {
    return type_.getHasSet();
  }

  @Override
  public boolean getHasList()
  {
    return type_.getHasList();
  }

  @Override
  public boolean getHasByteString()
  {
    return type_.getHasByteString();
  }
  
  @Override
  public boolean getIsTypeDef()
  {
    return type_.getIsTypeDef();
  }
  
  @Override
  public boolean getIsObjectType()
  {
    return type_.getIsObjectType();
  }
  
  @Override
  public boolean  getCanFailValidation()
  {
    return required_ || type_.getCanFailValidation();
  }
  
  @Override
  public void validate()
  {
    super.validate();
    
    if(type_ == null)
      getContext().raise(new ParserError("Field type must be specified"));
    else
      type_.validate();
  }

  public static AbstractSchema create(ModelElement parent, ParserContext context, boolean required)
  {
    AbstractSchema schema = AbstractSchema.createSchema(parent, context);
    
    return new Field(parent, context, schema, required, context.getName());
  }
  
  @Override
  protected void getReferencedTypes(Set<AbstractSchema> result)
  {
    super.getReferencedTypes(result);
    
    if(type_ instanceof ReferenceSchema ||
        type_ instanceof AbstractContainerSchema)
    {
      result.add(this);
    }
    else if(type_ instanceof ArraySchema)
    {
      result.add(((ArraySchema) type_).getItems());
    }
  }

  @Override
  public String toString()
  {
    return toString(new ValueMap<String, Object>()
        .insert("type", type_.getElementType(), "UNDEFINED")
        .insert("required", required_, null)
        );
  }
}
