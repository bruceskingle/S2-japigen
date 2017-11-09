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

package org.symphonyoss.s2.japigen.parser;

import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.util.Deque;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.Map;

import org.symphonyoss.s2.japigen.model.Model;

public class ModelSetParserContext
{
  private Map<URL, RootParserContext> generationContexts_ = new HashMap<>();
  private Map<URL, RootParserContext> referencedContexts_ = new HashMap<>();
  private Deque<RootParserContext>    parseQueue_         = new LinkedList<>();
  private Deque<Model>                validateQueue_      = new LinkedList<>();
  private Deque<Model>                generateQueue_      = new LinkedList<>();
  private Map<URL, Model>             modelMap_           = new HashMap<>();
    
  public void addGenerationSource(File file) throws ParsingException
  {
    try
    {
      URL url = file.toURI().toURL();
      
      RootParserContext context = new RootParserContext(this, url);
      generationContexts_.put(url, context);
      parseQueue_.add(context);
    }
    catch(IOException e)
    {
      throw new ParsingException(e);
    }
  }
  
  public void parse() throws ParsingException
  {
    Parser parser = new Parser();
    RootParserContext context;
    Model model;
    
    while((context = parseQueue_.pollFirst()) != null)
    {
        model = parser.parse(context);
        validateQueue_.add(model);
        modelMap_.put(context.getUrl(), model);
    }
    
    while((model = validateQueue_.pollFirst()) != null)
    {
        model.validate();
        
        generateQueue_.add(model);
        model.getContext().getRootParserContext().epilogue("Validation");
    }
  }

  public void addReferencedModel(URL url) throws ParsingException
  {
    if(!referencedContexts_.containsKey(url))
    {
      RootParserContext context = new RootParserContext(this, url);
      referencedContexts_.put(url, context);
      parseQueue_.add(context);
    }
  }
  
  public Model getModel(URL url)
  {
    return modelMap_.get(url);
  }
  
  public void generate(GenerationContext generationContext) throws GenerationException
  {
    for(Model model : generateQueue_)
    {
        model.generate(generationContext);
    }
  }
}
