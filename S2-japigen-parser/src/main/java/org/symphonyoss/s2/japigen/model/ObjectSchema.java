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
import java.util.Map;
import java.util.Set;

import org.symphonyoss.s2.japigen.parser.GenerationContext;
import org.symphonyoss.s2.japigen.parser.GenerationException;
import org.symphonyoss.s2.japigen.parser.ParserContext;

/**
 * Schema for an object.
 * 
 * @author Bruce Skingle
 *
 */
public class ObjectSchema extends Schema
{
  private Set<String>  requiredButUndefinedSet_ = new HashSet<>();
    
  public ObjectSchema(ModelElement parent, ParserContext context)
  {
    super(parent, context, "Object");
    
    ParserContext requiredFields = context.get("required");
    if(requiredFields != null)
    {
      for(ParserContext child : requiredFields)
      {
        String fieldName = child.getJsonNode().asText();
        
        if(requiredButUndefinedSet_.contains(fieldName))
          child.error("Duplication of required field \"%s\"", fieldName);
        else
          requiredButUndefinedSet_.add(fieldName);
      }
    }

    ParserContext properties = context.get("properties");
    if(properties==null)
    {
      context.error("Elements with \"type\": \"object\" require \"properties\":");
    }
    else
    {
      for(ParserContext child : properties)
      {
        String fieldName = child.getName();
        boolean required = requiredButUndefinedSet_.remove(fieldName);
        AbstractSchema field = Field.create(this, child, required);
        
        if(field != null)
          add(field);
      }
    }
    
    for(String requiredField : requiredButUndefinedSet_)
    {
      context.error("Required field \"%s\" is not defined!", requiredField);
    }
  }
  
  @Override
  public boolean getHasSet()
  {
    for(ModelElement child : getChildren())
    {
      if(child.getHasSet())
        return true;
    }
    
    return false;
  }
  
  @Override
  public boolean getHasList()
  {
    for(ModelElement child : getChildren())
    {
      if(child.getHasList())
        return true;
    }
    
    return false;
  }
  
  @Override
  public boolean getHasCollections()
  {
    for(ModelElement child : getChildren())
    {
      if(child.getHasSet() || child.getHasList())
        return true;
    }
    
    return false;
  }
  
  @Override
  public boolean getHasByteString()
  {
    for(ModelElement child : getChildren())
    {
      if(child.getHasByteString())
        return true;
    }
    
    return false;
  }

  @Override
  protected void getReferencedTypes(Set<Schema> result)
  {
    super.getReferencedTypes(result);
    
    for(ModelElement child : getChildren())
      child.getReferencedTypes(result);
  }

  @Override
  public void generate(GenerationContext generationContext, Map<String, Object> dataModel) throws GenerationException
  {
    if(getParent() instanceof Schemas)
    {
      getContext().info("ObjectSchema parent is Schemas for %s", getName());
      super.generate(generationContext, dataModel);
    }
    else
    {
      getContext().info("ObjectSchema ignored for generation (parent is %s for %s)", getParent().getClass(), getName());
    }
    
  }
}
