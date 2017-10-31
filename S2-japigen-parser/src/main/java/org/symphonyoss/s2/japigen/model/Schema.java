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

import java.util.List;

import org.symphonyoss.s2.japigen.model.ValueMap.Entry;
import org.symphonyoss.s2.japigen.parser.ParserContext;

/**
 * An abstract Schema object, which could be an object, reference to an object,
 * oneOf, allOf, or even a single field.
 * 
 * @author Bruce Skingle
 *
 */
public abstract class Schema
{
  private final Model         model_;
  private final ParserContext context_;
  private final String        type_;
  
  public Schema(Model model, ParserContext context, String type)
  {
    model_ = model;
    context_ = context;
    type_ = type;
  }

  public Model getModel()
  {
    return model_;
  }
  
  public ParserContext getContext()
  {
    return context_;
  }

  public String getName()
  {
    return context_.getName();
  }

  public String getType()
  {
    return type_;
  }

  protected Schema createSchema(ParserContext context)
  {
    return createSchema(model_, context);
  }
  
  /* package */ static Schema createSchema(Model model, ParserContext context)
  {
    SchemaBuilder builder = new SchemaBuilder(model, context);
    
    builder.build("allOf", (m, c, n) -> new AllOfSchema(m, n));
    builder.build("oneOf", (m, c, n) -> new OneOfSchema(m, n));
    builder.build("$ref", (m, c, n) -> new ReferenceSchema(m, c, n));
    builder.build("type", (m, c, n) -> Type.create(m, c, n));
    
    if(builder.getResult() == null)
    {
      ParserContext properties = context.get("properties");
      
      if(properties != null)
      {
        return new ObjectSchema(model, context);
      }
    }
    
    return builder.getResult();
  }
  
  @Override
  public String toString()
  {
    return type_ + '(' + getName() + ')';
  }

  protected String toString(StringBuffer details)
  {
    return type_ + '(' + getName() + details + ')';
  }
  
  protected String toString(List<?> children)
  {
    StringBuffer s = new StringBuffer();
       
    for(Object c : children)
    {
      s.append(',');
      s.append(c);
    }
    
    return toString(s);
  }
  
  protected String toString(ValueMap<String, Object> children)
  {
    StringBuffer s = new StringBuffer();
       
    for(Entry<String, Object> e : children)
    {
      s.append(',');
      s.append(e.getKey());
      s.append('=');
      s.append(e.getValue());
    }
    
    return toString(s);
  }
}

class SchemaBuilder
{
  private final Model         model_;
  private final ParserContext context_;
  private Schema              result_;
  private ParserContext       resultNode_;
        
  public SchemaBuilder(Model model, ParserContext context)
  {
    model_ = model;
    context_ = context;
  }

  void build(String name, ISchemaFactory factory)
  {
    ParserContext node = canBuildNode(name);
    
    if(node != null)
    {
      result_ = factory.create(model_, context_, node);
      resultNode_ = node;
    }
  }

  boolean canBuild(String name)
  {
    return canBuildNode(name) == null;
  }
  
  ParserContext canBuildNode(String name)
  {
    ParserContext node = context_.get(name);
    
    if(node != null)
    {
      if(resultNode_ == null)
      {
        return node;
      }
      else
      {
        context_.error("\"%s\" and \"%s\" may not both be present.", resultNode_.getName(), node.getName());
      }
    }
    return null;
  }

  Schema getResult()
  {
    return result_;
  }
}
