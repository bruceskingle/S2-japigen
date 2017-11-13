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

/**
 * Schema for an array.
 * 
 * @author Bruce Skingle
 *
 */
public class ArraySchema extends Schema
{
  private final AbstractSchema items_;
  private final String cardinality_;
  
  public ArraySchema(ModelElement parent, ParserContext context)
  {
    super(parent, context, "Array");

    ParserContext items = context.get("items");
    if(items==null)
    {
      context.error("Elements with \"type\": \"array\" require \"items\":");
      items_ = null;
    }
    else
    {
      items_ = AbstractSchema.createSchema(parent, items);
    }
    
    switch(context.getText(JAPIGEN.X_CARDINALITY, JAPIGEN.X_CARDINALITY_LIST))
    {
      case JAPIGEN.X_CARDINALITY_SET:
        cardinality_ = JAPIGEN.X_CARDINALITY_SET;
        break;
        
      default:
        cardinality_ = JAPIGEN.X_CARDINALITY_LIST;
    }
      
  }

  public AbstractSchema getItems()
  {
    return items_;
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
}
