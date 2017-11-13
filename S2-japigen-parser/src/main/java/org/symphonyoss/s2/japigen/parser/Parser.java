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

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.symphonyoss.s2.japigen.model.Model;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.github.fge.jsonschema.core.exceptions.ProcessingException;
import com.github.fge.jsonschema.core.report.ProcessingReport;
import com.github.fge.jsonschema.main.JsonSchema;
import com.github.fge.jsonschema.main.JsonSchemaFactory;

public class Parser
{
  private static Logger log_ = LoggerFactory.getLogger(Parser.class);

  private JsonSchema  schema_;
  
  public Parser() throws ParsingException
  {
    schema_ = getJsonSchemaFromClasspath("openapiv3.schema.json");
  }

  public Model parse(RootParserContext rootParserContext) throws ParsingException
  {
    try
    {
      rootParserContext.prologue();
      ObjectMapper mapper = new ObjectMapper();
      JsonNode rootNode = mapper.readTree(rootParserContext.getInputStream());
      
      ProcessingReport report = schema_.validate(rootNode);
      
      if(report.isSuccess())
      {
        log_.info("Schema validation passed.");
      }
      else
      {
        rootParserContext.error("Schema validation FAILED:");
        log_.error(report.toString());
  //      for(ProcessingMessage messge : report)
  //      {
  //        log_.error(messge.getMessage());
  //        log_.error(messge.asJson().toString());
  //      }
      }
      
      Model model = new Model(new ParserContext(rootParserContext, rootNode));
      
      rootParserContext.epilogue("Parsing");
      
      return model;
    }
    catch(ProcessingException | IOException e)
    {
      throw new ParsingException(e);
    }
  }
  
  public JsonSchema getJsonSchemaFromClasspath(String name) throws ParsingException
  {
    JsonSchemaFactory factory = JsonSchemaFactory.byDefault();
    InputStream is = Thread.currentThread().getContextClassLoader().getResourceAsStream(name);

    try
    {
      ObjectMapper mapper = new ObjectMapper();
      JsonNode jsonNode = mapper.readTree(is);
  
        
      return factory.getJsonSchema(jsonNode);
    }
    catch (IOException | ProcessingException e)
    {
      throw new ParsingException(e);
    }
  }

  public Model parse(String fileName) throws ParsingException
  {
    return parse(new File(fileName));
  }

  public Model parse(File file) throws ParsingException
  {
    
    
    try(FileInputStream in = new FileInputStream(file))
    {
      RootParserContext parserContext = new RootParserContext(file, in);
      
      return parse(parserContext);
    }
    catch (IOException e)
    {
      throw new ParsingException(e);
    }
  }
}
