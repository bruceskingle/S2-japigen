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

package org.symphonyoss.s2.japigen.test;

import java.io.File;

import org.symphonyoss.s2.common.writer.IndentedWriter;
import org.symphonyoss.s2.japigen.model.ModelElement;
import org.symphonyoss.s2.japigen.parser.GenerationContext;
import org.symphonyoss.s2.japigen.parser.JapigenException;
import org.symphonyoss.s2.japigen.parser.ModelSetParserContext;

public class TestParser
{
  public static void main(String[] argv) throws JapigenException
  {
//    System.err.format("Integer.MIN_VALUE %d%n", Integer.MIN_VALUE);
//    System.err.format("Integer.MAX_VALUE %d%n", Integer.MAX_VALUE);
//    System.err.format("Long.MIN_VALUE %d%n", Long.MIN_VALUE);
//    System.err.format("Long.MAX_VALUE %d%n", Long.MAX_VALUE);
//    System.err.format("Float.MIN_VALUE %f%n", Float.MIN_VALUE);
//    System.err.format("Float.MAX_VALUE %f%n", Float.MAX_VALUE);
//    System.err.format("Double.MIN_VALUE %f%n", Double.MIN_VALUE);
//    System.err.format("Double.MAX_VALUE %f%n", Double.MAX_VALUE);
//    
//    System.err.format("Double.MIN_VALUE %s%n", Double.MIN_VALUE);
//    System.err.format("Double.MAX_VALUE %s%n", Double.MAX_VALUE);
//    
//    Double twentyfive = 25.0;
//    System.err.println("25 " + twentyfive);
    
    ModelSetParserContext modelSetContext = new ModelSetParserContext();
    
    modelSetContext.addGenerationSource(new File("src/main/Resources/test/oneOfEverything.json"));
    
    modelSetContext.parse();
    
    IndentedWriter out = new IndentedWriter(System.out);
    
    modelSetContext.visitAllModels((model) ->
    {
      System.out.println("Model " + model);
      
      visit(out, model);
    });
    
    out.flush();
    
    GenerationContext generationContext = new GenerationContext("target/generated-sources", "target/proforma-sources", "target/proforma-copy");
    generationContext.addTemplateDirectory(new File("../S2-japigen-template-java/src/main/resources/japigen"));
    
//    generationContext.put("templateDebug", "true");
    
    modelSetContext.generate(generationContext);
  }

  private static void visit(IndentedWriter out, ModelElement model)
  {
    out.openBlock(model.toString());
    
    for(ModelElement child : model.getChildren())
      visit(out, child);
    
    out.closeBlock();
  }
}
