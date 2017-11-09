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
import java.util.HashSet;
import java.util.Locale;
import java.util.Set;

import org.symphonyoss.s2.common.fault.TransactionFault;

import freemarker.template.Configuration;
import freemarker.template.Version;

public class GenerationContext
{
  private MultiDirTemplateLoader templateLoader_         = new MultiDirTemplateLoader();
  private MultiDirTemplateLoader proformaTemplateLoader_ = new MultiDirTemplateLoader();
  private File                   targetDir_;
  private File                   proformaDir_;
  private File                   copyDir_;
  private Set<String>            languages_              = new HashSet<>();
  private Configuration          config_;
  private Configuration          proformaConfig_;

  public GenerationContext(String targetDirName, String proformaDirName, String copyDirName) throws GenerationException
  {
    this(new File(targetDirName), proformaDirName == null ? new File(targetDirName) : new File(proformaDirName),
        copyDirName == null ? null : new File(copyDirName));
  }
  
  public GenerationContext(File targetDir, File proformaDir, File copyDir) throws GenerationException
  {
    validateDir(targetDir);
    
    if(proformaDir != null)
    {
      validateDir(proformaDir);
    }
    
    if(copyDir != null)
    {
      validateDir(copyDir);
    }
    
    targetDir_ = targetDir;
    proformaDir_ = proformaDir;
    copyDir_ = copyDir;
    
    config_ = new Configuration(new Version(2, 3, 25));
    
    config_.setTemplateLoader(templateLoader_);
    config_.setDefaultEncoding("UTF-8");
    config_.setLocale(Locale.US);
    
    proformaConfig_ = new Configuration(new Version(2, 3, 25));
    
    proformaConfig_.setTemplateLoader(proformaTemplateLoader_);
    proformaConfig_.setDefaultEncoding("UTF-8");
    proformaConfig_.setLocale(Locale.US);
    
    
  }
  
  private void validateDir(File targetDir) throws GenerationException
  {
    if(!targetDir.exists())
    {
      if(!targetDir.mkdirs())
      {
        throw new GenerationException("Target dir \"" + targetDir.getAbsolutePath() + "\" does not exist and cannot be created.");
      }
    }
    else
    {
      if(!targetDir.isDirectory())
      {
        throw new GenerationException("Target dir \"" + targetDir.getAbsolutePath() + "\" is not a directory.");
      }
      else if(!targetDir.canWrite())
      {
        throw new GenerationException("Target dir \"" + targetDir.getAbsolutePath() + "\" is not writable.");
      }
    }
  }

  /**
   * This is analogous to copying the templates into a working directory so later additions
   * take precedence over earlier ones.
   * 
   * @param file A template directory.
   */
  public void addTemplateDirectory(File dir)
  {
    addTemplateDirectory(dir, templateLoader_);
  }
  
  /**
   * This is analogous to copying the templates into a working directory so later additions
   * take precedence over earlier ones.
   * 
   * @param file A template directory.
   */
  public void addProformaTemplateDirectory(File dir)
  {
    addTemplateDirectory(dir, proformaTemplateLoader_);
  }


  public void addTemplateDirectory(File dir, MultiDirTemplateLoader templateLoader)
  {
    if(!dir.isDirectory())
      throw new IllegalArgumentException("\""
          + dir.getAbsolutePath()
          + "\" is not a directory");
    
    try
    {
      templateLoader.addTemplateDirectory(dir);
    }
    catch (IOException e)
    {
      throw new TransactionFault("Failed to add \""
          + dir.getAbsolutePath()
          + "\"", e);
    }
    
    File[] languages = dir.listFiles();
    
    if(languages != null)
    {
      for(File f : languages)
      {
        if(f.isDirectory())
          languages_.add(f.getName());
      }
    }
  }
  
  public Configuration getFreemarkerConfig()
  {
    return config_;
  }

  public Configuration getProformaConfig()
  {
    return proformaConfig_;
  }

  public Set<String> getTemplatesFor(String language, String type)
  {
    return templateLoader_.getTemplatesFor(language, type);
  }
  
  public Set<String> getProformaTemplatesFor(String language, String type)
  {
    return proformaTemplateLoader_.getTemplatesFor(language, type);
  }

  public Set<String> getLanguages()
  {
    return languages_;
  }

  public File getTargetDir()
  {
    return targetDir_;
  }

  public File getProformaDir()
  {
    return proformaDir_;
  }

  public File getCopyDir()
  {
    return copyDir_;
  }
}
