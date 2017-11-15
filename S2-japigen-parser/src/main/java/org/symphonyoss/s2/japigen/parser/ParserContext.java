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

package org.symphonyoss.s2.japigen.parser;

import java.util.Iterator;
import java.util.Map.Entry;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.fasterxml.jackson.databind.JsonNode;

public class ParserContext implements Iterable<ParserContext>
{
  private static Logger log_ = LoggerFactory.getLogger(ParserContext.class);

  private final ParserContext     parent_;
  private final RootParserContext rootParserContext_;
  private final String            path_;
  private final JsonNode          jsonNode_;
  private final String            name_;

  /* package */ ParserContext(RootParserContext rootParserContext, JsonNode rootNode)
  {
    parent_ = this;
    rootParserContext_ = rootParserContext;
    path_ = "#";
    jsonNode_ = rootNode;
    name_ = "/";
  }
  
  public ParserContext(ParserContext parent, String name, JsonNode jsonNode)
  {
    parent_ = parent;
    rootParserContext_ = parent.getRootParserContext();
    path_ = parent.path_ + "/" + name;
    jsonNode_ = jsonNode;
    name_ = name;
  }
  
  public ParserContext getParent()
  {
    return parent_;
  }

  public ParserContext get(String name)
  {
    if(jsonNode_.get(name) == null)
    {
      return null;
    }
    
    return new ParserContext(this, name, jsonNode_.get(name));
  }

  public RootParserContext getRootParserContext()
  {
    return rootParserContext_;
  }

  public String getPath()
  {
    return path_;
  }

  public JsonNode getJsonNode()
  {
    return jsonNode_;
  }

  public String getName()
  {
    return name_;
  }

  @Override
  public Iterator<ParserContext> iterator()
  {
    if(jsonNode_.isObject())
      return new FieldIterator();
    
    if(jsonNode_.isArray())
      return new ArrayIterator();
    
    throw new RuntimeException("Unknown JsonNode type " + jsonNode_);
  }
  
  public class FieldIterator implements Iterator<ParserContext>
  {
    Iterator<Entry<String, JsonNode>> it_ = jsonNode_.fields();
    
    @Override
    public boolean hasNext()
    {
      return it_.hasNext();
    }

    @Override
    public ParserContext next()
    {
      Entry<String, JsonNode> e = it_.next();
      return new ParserContext(ParserContext.this, e.getKey(), e.getValue());
    }
  }
  
  public class ArrayIterator implements Iterator<ParserContext>
  {
    Iterator<JsonNode> it_    = jsonNode_.elements();
    int                index_ = 0;
    
    @Override
    public boolean hasNext()
    {
      return it_.hasNext();
    }

    @Override
    public ParserContext next()
    {
      return new ParserContext(ParserContext.this, String.format("[%d]", index_++), it_.next());
    }
  }

  public void error(String format, Object ...args)
  {
    rootParserContext_.error(String.format("%n%nERROR: %s%nat %s%n%n", String.format(format, args), path_));
  }
  
  public void info(String format, Object ...args)
  {
    log_.info(String.format("%s%nat %s", String.format(format, args), path_));
  }

  public String getTextNode(String fieldName)
  {
    JsonNode node = jsonNode_.get(fieldName);
    
    if(node != null)
    {

      if(!node.isTextual())
        error("Expected \"%s\" to be a string value not %s", fieldName, node.getNodeType());
      
      return node.asText();
    }
    
    return "";
  }

  public Long getLongNode(String fieldName)
  {
    JsonNode node = jsonNode_.get(fieldName);
    
    if(node != null)
    {
      if(!node.isNumber())
        error("Expected \"%s\" to be a long value not %s", fieldName, node.getNodeType());
      
      return node.asLong();
    }
    
    return null;
  }
  
  public long getLongNode(String fieldName, long defaultValue)
  {
    JsonNode node = jsonNode_.get(fieldName);
    
    if(node != null)
    {
      if(!node.isNumber())
        error("Expected \"%s\" to be a long value not %s", fieldName, node.getNodeType());
      
      return node.asLong(defaultValue);
    }
    
    return defaultValue;
  }

  public Double getDoubleNode(String fieldName)
  {
    JsonNode node = jsonNode_.get(fieldName);
    
    if(node != null)
    {

      if(!node.isNumber())
        error("Expected \"%s\" to be a double value not %s", fieldName, node.getNodeType());
      
      return node.asDouble();
    }
    
    return null;
  }

  public double getDoubleNode(String fieldName, double defaultValue)
  {
    JsonNode node = jsonNode_.get(fieldName);
    
    if(node != null)
    {

      if(!node.isNumber())
        error("Expected \"%s\" to be a double value not %s", fieldName, node.getNodeType());
      
      return node.asDouble(defaultValue);
    }
    
    return defaultValue;
  }

  @Override
  public String toString()
  {
    return "ParserContext(" + jsonNode_ + ")";
  }

  public String getText(String name)
  {
    JsonNode jsonNode = getJsonNode().get(name);
    
    if(jsonNode == null)
      return null;
    
    return jsonNode.asText();
  }
  
  public String getText(String name, String defaultValue)
  {
    JsonNode jsonNode = getJsonNode().get(name);
    
    if(jsonNode == null)
      return defaultValue;
    
    return jsonNode.asText();
  }
}
