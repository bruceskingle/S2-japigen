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

import org.symphonyoss.s2.japigen.parser.GenerationContext;
import org.symphonyoss.s2.japigen.parser.JapigenException;
import org.symphonyoss.s2.japigen.parser.ModelSetParserContext;

public class TestParser
{
  public static void main(String[] argv) throws JapigenException
  {
    ModelSetParserContext modelSetContext = new ModelSetParserContext();
    
    modelSetContext.addGenerationSource(new File("src/main/Resources/test/oneOfEverything.json"));
    
    modelSetContext.parse();
    
    GenerationContext generationContext = new GenerationContext("target/generated-sources", "target/proforma-sources", "target/proforma-copy");
    generationContext.addTemplateDirectory(new File("../S2-japigen-template-java/src/main/resources/japigen"));
    
    modelSetContext.generate(generationContext);
  }
}
