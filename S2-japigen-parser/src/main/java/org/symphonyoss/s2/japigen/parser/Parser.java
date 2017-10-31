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
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;

import org.symphonyoss.s2.japigen.model.Model;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.github.fge.jsonschema.core.exceptions.ProcessingException;
import com.github.fge.jsonschema.core.report.ProcessingReport;
import com.github.fge.jsonschema.main.JsonSchema;
import com.github.fge.jsonschema.main.JsonSchemaFactory;

public class Parser
{
  private JsonSchema  schema_;
  
  public Parser() throws JsonProcessingException, ProcessingException, IOException
  {
    schema_ = getJsonSchemaFromClasspath("openapiv3.schema.json");
  }

  public Model parse(RootParserContext parserContext) throws IOException, ProcessingException
  {
    parserContext.info("Parsing %s...", parserContext.getInputSource());
    ObjectMapper mapper = new ObjectMapper();
    JsonNode rootNode = mapper.readTree(parserContext.getInputStream());
    
    ProcessingReport report = schema_.validate(rootNode);
    
    if(report.isSuccess())
    {
      System.out.println("That seems OK");
      System.out.println(report);
    }
    else
    {
      System.err.println(report);
    }
    Model model = new Model(new ParserContext(rootNode));
    
    return model;
  }
  
  public JsonSchema getJsonSchemaFromClasspath(String name) throws ProcessingException, JsonProcessingException, IOException
  {
    JsonSchemaFactory factory = JsonSchemaFactory.byDefault();
    InputStream is = Thread.currentThread().getContextClassLoader().getResourceAsStream(name);
    
//    try
//    {
//      byte[] buf = new byte[1024];
//      int nbytes;
//      while((nbytes = is.read(buf))>0)
//        System.err.write(buf, 0, nbytes);
//    }
//    catch(IOException e)
//    {
//      e.printStackTrace();
//    }
    
    ObjectMapper mapper = new ObjectMapper();
    JsonNode jsonNode = mapper.readTree(is);

      
    return factory.getJsonSchema(jsonNode);
  }

  public Model parse(String fileName) throws FileNotFoundException, IOException, ProcessingException
  {
    return parse(new File(fileName));
  }

  public Model parse(File file) throws FileNotFoundException, IOException, ProcessingException
  {
    
    
    try(FileInputStream in = new FileInputStream(file))
    {
      RootParserContext parserContext = new RootParserContext(file, in);
      
      return parse(parserContext);
    }
  }
}
