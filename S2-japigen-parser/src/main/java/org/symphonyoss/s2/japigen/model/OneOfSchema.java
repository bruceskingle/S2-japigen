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

import java.util.Map;
import java.util.Set;

import org.symphonyoss.s2.japigen.Japigen;
import org.symphonyoss.s2.japigen.parser.GenerationContext;
import org.symphonyoss.s2.japigen.parser.ParserContext;
import org.symphonyoss.s2.japigen.parser.error.ParserError;

public class OneOfSchema extends AbstractContainerSchema
{
  private Discriminator discriminator_;

  public OneOfSchema(ModelElement parent, ParserContext context, ParserContext node, String name)
  {
    super(parent, context, node, "OneOfSchema", name);
    
    ParserContext d = context.get(Japigen.DISCRIMINATOR);
    
    if(d == null)
    {
      context.raise(new ParserError("oneOf fields require a discriminator"));
    }
    else
    {
      discriminator_ = new Discriminator(this, d);
    }
    
    if(!(parent instanceof Schemas))
    {
      context.raise(new ParserError("Nested in-line object definitions are not supported, move this to Components/Schemas amd refer to is with $ref"));
    }
  }

  @Override
  public void validate()
  {
    super.validate();
    
    for(ModelElement child : getChildren())
    {
      if(child instanceof ObjectSchema)
      {
        getContext().raise(new ParserError("OneOf children must be declared as $ref not as in-line objects. This is a japigen restriction."));
      }
      else if(child instanceof ReferenceSchema)
      {
        AbstractSchema type = ((ReferenceSchema)child).getType();
        
        if(type instanceof TypeDef)
        {
          type = ((TypeDef)type).getType();
        }
        if(!(type instanceof ObjectSchema))
        {
          getContext().raise(new ParserError("OneOf children must be declared as $ref to an object, not a %s",
              type==null ? "null" : type.getClass().getName()));
        }
      }
    }
    
//    if(getParent() instanceof Schemas)
//    {
//      getContext().raise(new ParserInfo("OneOf parent is Schemas for %s", getName()));
//    }
//    else
//    {
//      getContext().raise(new ParserError("OneOf is only allowed in a top level schema (parent is %s for %s)", getParent().getClass(), getName()));
//    }
  }

  public Discriminator getDiscriminator()
  {
    return discriminator_;
  }

  @Override
  protected void getReferencedTypes(Set<AbstractSchema> result)
  {
    super.getReferencedTypes(result);
    
    result.add(this);
  }

  @Override
  protected void generateChildren(GenerationContext generationContext, Map<String, Object> dataModel)
  {}
}
