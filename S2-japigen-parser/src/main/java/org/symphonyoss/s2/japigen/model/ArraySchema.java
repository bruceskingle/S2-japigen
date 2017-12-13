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

import org.symphonyoss.s2.japigen.JAPIGEN;
import org.symphonyoss.s2.japigen.parser.ParserContext;
import org.symphonyoss.s2.japigen.parser.error.ArraysRequireElementsError;
import org.symphonyoss.s2.japigen.parser.error.ParserError;

/**
 * Schema for an array.
 * 
 * @author Bruce Skingle
 *
 */
public class ArraySchema extends Type
{
  private final AbstractSchema items_;
  private final String cardinality_;
  private final Long minItems_;
  private final Long maxItems_;
  
  public ArraySchema(ModelElement parent, ParserContext context)
  {
    super(parent, context, "Array");

    ParserContext items = context.get("items");
    if(items==null)
    {
      context.raise(new ArraysRequireElementsError());
      items_ = null;
    }
    else
    {
      items_ = AbstractSchema.createSchema(this, items);
    }
    
    minItems_ = context.getLongNode("minItems");
    maxItems_ = context.getLongNode("maxItems");
    
    switch(context.getText(JAPIGEN.X_CARDINALITY, JAPIGEN.X_CARDINALITY_LIST))
    {
      case JAPIGEN.X_CARDINALITY_SET:
        cardinality_ = JAPIGEN.X_CARDINALITY_SET;
        break;
        
      default:
        cardinality_ = JAPIGEN.X_CARDINALITY_LIST;
    }
      
  }

  @Override
  public void validate()
  {
    super.validate();
    
    if(items_ == null)
      getContext().raise(new ParserError("Array items must be specified"));
    else
      items_.validate();
  }

  public AbstractSchema getItems()
  {
    return items_;
  }

  public Long getMinItems()
  {
    return minItems_;
  }

  public Long getMaxItems()
  {
    return maxItems_;
  }

  public String getCardinality()
  {
    return cardinality_;
  }
  
  @Override
  public boolean getHasSet()
  {
    return JAPIGEN.X_CARDINALITY_SET.equals(cardinality_);
  }
  
  @Override
  public boolean getHasList()
  {
    return JAPIGEN.X_CARDINALITY_LIST.equals(cardinality_);
  }
  
  @Override
  public boolean getHasCollections()
  {
    return true;
  }
  
  @Override
  public boolean getHasByteString()
  {
    return items_.getHasByteString();
  }
  
  @Override
  public void getReferencedTypes(Set<Schema> result)
  {
    super.getReferencedTypes(result);
    
    items_.getReferencedTypes(result);
  }

  @Override
  public boolean getCanFailValidation()
  {
    return minItems_ != null || maxItems_ != null || super.getCanFailValidation();
  }
}
