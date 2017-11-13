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

package org.symphonyoss.s2.japigen.model;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.symphonyoss.s2.japigen.JAPIGEN;
import org.symphonyoss.s2.japigen.parser.GenerationContext;
import org.symphonyoss.s2.japigen.parser.GenerationException;
import org.symphonyoss.s2.japigen.parser.ParserContext;

import com.google.common.io.Files;

import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateException;

public class ModelElement
{
  private static Logger             log_      = LoggerFactory.getLogger(ModelElement.class);

  private final ModelElement        parent_;
  private final ParserContext       parserContext_;
  private final String              elementType_;
  private final String              name_;
  private final String              camelName_;
  private final String              camelCapitalizedName_;
  private final String              snakeName_;
  private final String              snakeCapitalizedName_;

  private List<ModelElement>        children_ = new ArrayList<>();
  private Map<String, ModelElement> nameMap_  = new HashMap<>();
  private Map<String, IPathNameConstructor> templatePathBuilderMap_  = new HashMap<>();
  private Map<String, IPathNameConstructor> proformaPathBuilderMap_  = new HashMap<>();

  private String description_;

  private String format_ = "";

  public ModelElement(ModelElement parent, ParserContext parserContext, String type)
  {
    parent_ = parent;
    parserContext_ = parserContext;
    elementType_ = type;
    description_ = parserContext.getText("description");
    format_ = parserContext.getText("format", "");
    
    name_ = parserContext.getName();
    
    camelName_ = toCamelCase(name_);
    camelCapitalizedName_ = capitalize(camelName_);
    snakeName_ = toSnakeCase(name_);
    snakeCapitalizedName_ = capitalize(snakeName_);
    
    IPathNameConstructor defaultPathNameConstructor = new PathNameConstructor();
    
    templatePathBuilderMap_.put("java", new JavaPathNameConstructor(JAPIGEN.JAVA_GEN_PACKAGE));
    templatePathBuilderMap_.put(null, defaultPathNameConstructor);
    
    proformaPathBuilderMap_.put("java", new JavaPathNameConstructor(JAPIGEN.JAVA_FACADE_PACKAGE));
    proformaPathBuilderMap_.put(null, defaultPathNameConstructor);
  }

  private String toCamelCase(String name)
  {
    int i=0;
    StringBuilder s = new StringBuilder();
    
    while(i<name.length() && name.charAt(i)=='_')
    {
      s.append('_');
      i++;
    }
    
    if(i<name.length())
    {
      s.append(Character.toLowerCase(name.charAt(i++)));
    }
    
    while(i<name.length())
    {
      char c = name.charAt(i++);
   
      if(c=='_' && i<name.length())
      {
        s.append(Character.toUpperCase(name.charAt(i++)));
      }
      else
      {
        s.append(c);
      }
    }
    return s.toString();
  }
  
  private String toSnakeCase(String name)
  {
    int i=0;
    StringBuilder s = new StringBuilder(Character.toLowerCase(name.charAt(i)));
    
    while(i<name.length())
    {
      char c = name.charAt(i++);
      
      if(Character.isUpperCase(c))
      {
        s.append('_');
        s.append(Character.toLowerCase(c));
      }
      else
      {
        s.append(c);
      }
    }
    return s.toString();
  }

  public static String capitalize(String name)
  {
    return name.substring(0, 1).toUpperCase() + name.substring(1);
  }

  public Model getModel()
  {
    return parent_.getModel();
  }
  
  public String getName()
  {
    return name_;
  }

  public String getCamelName()
  {
    return camelName_;
  }

  public String getCamelCapitalizedName()
  {
    return camelCapitalizedName_;
  }

  public String getSnakeName()
  {
    return snakeName_;
  }

  public String getSnakeCapitalizedName()
  {
    return snakeCapitalizedName_;
  }

  public String getDescription()
  {
    return description_;
  }

  public String getFormat()
  {
    return format_;
  }

  public boolean getHasSet()
  {
    return false;
  }
  
  public boolean getHasList()
  {
    return false;
  }
  
  public boolean getHasCollections()
  {
    return false;
  }
  
  public boolean getHasByteString()
  {
    return false;
  }
  
  public void validate()
  {
    log_.debug("Validate " + toString());
    
    for(ModelElement child : children_)
      child.validate();
  }

  public void add(ModelElement e)
  {
    if(e != null)
      children_.add(e);
  }

  public ModelElement getParent()
  {
    return parent_;
  }

  public ParserContext getContext()
  {
    return parserContext_;
  }

  public String getElementType()
  {
    return elementType_;
  }

  public List<ModelElement> getChildren()
  {
    return children_;
  }
  
  public void generate(GenerationContext generationContext, Map<String, Object> dataModel) throws GenerationException
  {
    log_.debug("Generate prologue {}", toString());
    
    for(ModelElement child : children_)
      child.generate(generationContext, dataModel);
    
    for(String language : generationContext.getLanguages())
    {
      Set<String> templates = generationContext.getTemplatesFor(JAPIGEN.TEMPLATE, language, getElementType());
      
      if(!templates.isEmpty())
      {
        dataModel.remove(JAPIGEN.IS_FACADE);
        generate(generationContext, dataModel, templates, language, templatePathBuilderMap_, generationContext.getFreemarkerConfig(), generationContext.getTargetDir(), null);
      }
      
      templates = generationContext.getTemplatesFor(JAPIGEN.PROFORMA, language, getElementType());
      
      if(!templates.isEmpty())
      {
        dataModel.put(JAPIGEN.IS_FACADE, "true");
        generate(generationContext, dataModel, templates, language, proformaPathBuilderMap_, generationContext.getFreemarkerConfig(), generationContext.getProformaDir(), generationContext.getCopyDir());
      }
    }
    
    log_.debug("Generate epilogue {}", toString());
  }
  
  private void generate(GenerationContext generationContext, Map<String, Object> dataModel, Set<String> templates,
      String language, Map<String, IPathNameConstructor> pathBuilderMap, Configuration freemarkerConfig,
      File targetDir, File copyDir) throws GenerationException
  {
    IPathNameConstructor pathBuilder = pathBuilderMap.get(language);
    
    if(pathBuilder == null)
      pathBuilder = pathBuilderMap.get(null);
    
    log_.debug("Generate generate {}", toString());
    
    for(String templateName : templates)
    {
      log_.debug("Generate generate {} {}", toString(), templateName);
      
      File templateFile = new File(templateName);
      
      dataModel.put(JAPIGEN.TEMPLATE_NAME, templateName);
      
      String  className = pathBuilder.constructFile(dataModel, language, templateFile.getName(), this);
      
      if(className != null)
      {
        
            
        log_.debug("class " + className);
        
        try
        {
          
          Template template = freemarkerConfig.getTemplate(templateName);
          
          generate(generationContext, template, className, dataModel, targetDir, copyDir);

        } catch (IOException e)
        {
          throw new GenerationException("ERROR processing " + name_ + " template " +
              templateName, e);
        }
      }
    }
  }

  private void generate(GenerationContext generationContext, Template template,
      String className, Map<String, Object> dataModel,
      File targetDir, File copyDir) throws GenerationException
  {
    File genPath = new File(targetDir, className);
    
    genPath.getParentFile().mkdirs();
    
    dataModel.put("model", this);
    
    try(FileWriter writer = new FileWriter(genPath))
    {
      template.process(dataModel, writer);
    } 
    catch (TemplateException | IOException e)
    {
      //dumpMap("", dataModel, new HashSet<Object>());
      
      throw new GenerationException(e);
    }
    
    if(copyDir != null)
    {
      File copyPath = new File(copyDir, className);
    
      if(copyPath.exists())
      {
        log_.info("Proforma " + copyPath + " exists, not copying");
      }
      else
      {
        copyPath.getParentFile().mkdirs();
        try
        {
          Files.copy(genPath, copyPath);
        }
        catch (IOException e)
        {
          throw new GenerationException(e);
        }
      }
    }
  }

  protected void add(String name, ModelElement element)
  {
    if(element != null)
    {
      nameMap_.put(name, element);
      add(element);
    }
  }
  
  public ModelElement getByPath(String[] pathNames, int index)
  {
    if(pathNames.length <= index)
      return null;
    
    ModelElement modelElement = nameMap_.get(pathNames[index]);
    
    if(pathNames.length == index + 1)
      return modelElement;
    
    if(modelElement instanceof ModelElement)
      return ((ModelElement) modelElement).getByPath(pathNames, index + 1);
      
    return null;
  }
}
