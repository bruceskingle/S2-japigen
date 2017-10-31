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

import java.util.ArrayList;
import java.util.List;

import org.symphonyoss.s2.japigen.parser.ParserContext;

public abstract class AbstractContainerSchema extends ObjectOrReferenceSchema
{
  private List<ObjectOrReferenceSchema> children_ = new ArrayList<>();
    
  public AbstractContainerSchema(Model model, ParserContext context, String type)
  {
    super(model, context, type);
    
    for(ParserContext child : context)
    {
      Schema childSchema = createSchema(child);
      
      if(childSchema instanceof ObjectOrReferenceSchema)
        children_.add((ObjectOrReferenceSchema) childSchema);
      else
        child.error("Expected an Object Schema, but found " + childSchema);
        
    }
  }

  public List<ObjectOrReferenceSchema> getChildren()
  {
    return children_;
  }
  
  @Override
  public String toString()
  {
    return super.toString(children_);
  }
}
