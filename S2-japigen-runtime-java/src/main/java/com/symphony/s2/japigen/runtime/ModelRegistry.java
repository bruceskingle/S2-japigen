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

package com.symphony.s2.japigen.runtime;

import java.io.IOException;
import java.io.Reader;
import java.util.Collection;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.symphonyoss.s2.common.dom.json.IJsonDomNode;
import org.symphonyoss.s2.common.dom.json.IJsonObject;
import org.symphonyoss.s2.common.dom.json.ImmutableJsonObject;
import org.symphonyoss.s2.common.dom.json.jackson.JacksonAdaptor;
import org.symphonyoss.s2.common.exception.BadFormatException;
import org.symphonyoss.s2.common.http.IUrlPathServlet;
import org.symphonyoss.s2.common.reader.LinePartialReader;
import org.symphonyoss.s2.common.reader.LinePartialReader.Factory;

import com.fasterxml.jackson.core.JsonParser.Feature;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

public class ModelRegistry implements IModelRegistry
{
  private static final Logger LOG = LoggerFactory.getLogger(ModelRegistry.class);
  
  private Map<String, IModelObjectFactory<?,?>>  factoryMap_ = new HashMap<>();
  private ObjectMapper  mapper_ = new ObjectMapper().configure(Feature.AUTO_CLOSE_SOURCE, false);
  private List<IUrlPathServlet> servlets_ = new LinkedList<>();
  private List<IModel>   models_ = new LinkedList<>();
  
  @Override
  public IModelRegistry register(IModel factory)
  {
    models_.add(factory);
    factory.registerWith(this);
    return this;
  }
  
  @Override
  public IModelRegistry register(String name, IModelObjectFactory<?,?> factory)
  {
    factoryMap_.put(name, factory);
    return this;
  }
  
  @Override
  public IModelObject newInstance(ImmutableJsonObject jsonObject) throws BadFormatException
  {
    String typeId = jsonObject.getString(JapigenRuntime.JSON_TYPE);
    IModelObjectFactory<?,?> factory = factoryMap_.get(typeId);
    
    if(factory == null)
      throw new BadFormatException("Unknown type \"" + typeId + "\"");
    
    return factory.newInstance(jsonObject);
  }
  
  @Override
  public IModelObject parseOne(Reader reader) throws IOException, BadFormatException
  {
    try
    {
      JsonNode tree = mapper_.readTree(reader);
      
      IJsonDomNode adapted = JacksonAdaptor.adapt(tree);
      
      if(adapted instanceof IJsonObject)
      {
        return newInstance((ImmutableJsonObject) adapted.immutify());
      }
      else
      {
        throw new BadFormatException("Expected a JSON Object but read a " + adapted.getClass().getName());
      }
    }
    catch(JsonProcessingException e)
    {
      throw new BadFormatException("Failed to parse input", e);
    }
  }

  @Override
  public void parseStream(Reader reader, IModelObjectConsumer consumer) throws BadFormatException
  {
    try(Factory readerFactory = new LinePartialReader.Factory(reader))
    {
      LinePartialReader partialReader;
      
      while((partialReader = readerFactory.getNextReader())!=null)
      {
        try
        {
          consumer.consume(parseOne(partialReader));
        }
        finally
        {
          partialReader.close();
        }
      }
    }
    catch (IOException e)
    {
      LOG.error("Failed to close LinePartialReader.Factory", e);
    }
  }

  @Override
  public Collection<IUrlPathServlet> getServlets()
  {
    return servlets_;
  }

  @Override
  public void start()
  {
    for(IModel model : models_)
      model.start();
  }

  @Override
  public void stop()
  {
    for(IModel model : models_)
      model.stop();
  }
}
