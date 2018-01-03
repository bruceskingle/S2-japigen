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

package org.symphonyoss.s2.japigen;

import java.io.File;

import org.symphonyoss.s2.common.writer.IndentedWriter;
import org.symphonyoss.s2.japigen.model.ModelElement;
import org.symphonyoss.s2.japigen.parser.GenerationContext;
import org.symphonyoss.s2.japigen.parser.JapigenException;
import org.symphonyoss.s2.japigen.parser.ModelSetParserContext;
import org.symphonyoss.s2.japigen.parser.log.Slf4jLogFactoryAdaptor;

public class Japigen
{
  /* General Constants */
  public static final String TEMPLATE            = "template";
  public static final String PROFORMA            = "proforma";

  /* JSON Constants */
  public static final String X_MODEL             = "x-japigen-model";
  public static final String X_ID                = "x-japigen-id";
  public static final String X_ATTRIBUTES        = "x-japigen-attributes";
  public static final String X_CARDINALITY       = "x-japigen-cardinality";
  public static final String X_CARDINALITY_LIST  = "LIST";
  public static final String X_CARDINALITY_SET   = "SET";
  public static final String DISCRIMINATOR       = "discriminator";
  public static final String PROPERTY_NAME       = "propertyName";
  public static final String MAPPING             = "mapping";
  public static final String ENUM                = "enum";

  /* Root property names in the template data model */

  public static final String MODEL               = "model";

  public static final String JAVA_GEN_PACKAGE    = "javaGenPackage";
  public static final String JAVA_FACADE_PACKAGE = "javaFacadePackage";

  public static final String YEAR                = "year";
  public static final String YEAR_MONTH          = "yearMonth";
  public static final String DATE                = "date";

  public static final String IS_FACADE           = "isFacade";
  public static final String TEMPLATE_NAME       = "templateName";
  public static final String TEMPLATE_DEBUG      = "templateDebug";
  public static final String PATHS               = "paths";
  
  /**
   * Launcher.
   * 
   * @param argv command line arguments.
   * @throws JapigenException If anything goes wrong.
   */
  public static void main(String[] argv) throws JapigenException
  {
    if(argv.length==0)
      System.err.println("usage: japigen filename [filename...]");
    else
      for(String fileName : argv)
        japigen(fileName);
  }
  
  /**
   * Parse and code generate from the given file name which is expected to contain
   * an OpenAPI 3 spec.
   * 
   * @param fileName A file name pointing to an OpenAPI 3 spec.
   * @throws JapigenException If there is a parse or code generation error.
   */
  public static void japigen(String fileName) throws JapigenException
  {    
    ModelSetParserContext modelSetContext = new ModelSetParserContext(new Slf4jLogFactoryAdaptor());
    
    modelSetContext.addGenerationSource(new File(fileName));
    
    modelSetContext.process();
    
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
