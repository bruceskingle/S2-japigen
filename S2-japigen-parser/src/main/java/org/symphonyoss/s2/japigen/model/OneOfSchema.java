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

import org.symphonyoss.s2.japigen.parser.GenerationContext;
import org.symphonyoss.s2.japigen.parser.ParserContext;

public class OneOfSchema extends AbstractContainerSchema
{
  private ParserContext discriminator_;

  public OneOfSchema(ModelElement parent, ParserContext context, ParserContext node)
  {
    super(parent, context, node, "OneOf");
    
    discriminator_ = context.get("discriminator");
    
    if(discriminator_ == null)
    {
      context.error("oneOf fields require a discriminator");
    }
  }

  @Override
  protected void getReferencedTypes(Set<Schema> result)
  {
    super.getReferencedTypes(result);
    
    result.add(this);
  }

  @Override
  protected void generateChildren(GenerationContext generationContext, Map<String, Object> dataModel)
  {}

  @Override
  public void validate()
  {
    super.validate();
    
    if(getParent() instanceof Schemas)
    {
      getContext().info("OneOf parent is Schemas for %s", getName());
    }
    else
    {
      getContext().error("OneOf is only allowed in a top level schema (parent is %s for %s)", getParent().getClass(), getName());
    }
  }
}
