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

package org.symphonyoss.s2.japigen.test;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;

import org.symphonyoss.s2.japigen.parser.GenerationContext;
import org.symphonyoss.s2.japigen.parser.GenerationException;
import org.symphonyoss.s2.japigen.parser.ModelSetParserContext;

import com.github.fge.jsonschema.core.exceptions.ProcessingException;

public class TestParser
{
  public static void main(String[] argv) throws FileNotFoundException, IOException, ProcessingException, GenerationException
  {
    ModelSetParserContext modelSetContext = new ModelSetParserContext();
    
    modelSetContext.addGenerationSource(new File("src/main/Resources/s2-typedef.json"));
    //modelSetContext.addGenerationSource(new File("src/main/Resources/s2.json"));
    
    modelSetContext.parse();
    
    GenerationContext generationContext = new GenerationContext("target/generated-sources", null);
    generationContext.addTemplateDirectory(new File("../S2-japigen-template-java/src/main/resources/japigen/template"));
    generationContext.addProformaTemplateDirectory(new File("../S2-japigen-template-java/src/main/resources/japigen/proforma"));
    
    modelSetContext.generate(generationContext);
    
//    Parser parser = new Parser();
//    Model  s2TypedefModel  = parser.parse("src/main/Resources/s2-typedef.json");
//    
//    Model  s2Model  = parser.parse("src/main/Resources/s2.json");
//    
//    Model  petModel  = parser.parse("src/main/Resources/petStore.json");
//    
//    Model  testModel  = parser.parse("src/main/Resources/testCases.json");
  }
}
