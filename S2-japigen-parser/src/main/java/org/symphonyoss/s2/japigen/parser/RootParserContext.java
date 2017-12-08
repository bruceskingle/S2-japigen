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
import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URI;
import java.net.URL;

import org.symphonyoss.s2.common.fault.CodingFault;
import org.symphonyoss.s2.common.fault.ProgramFault;
import org.symphonyoss.s2.japigen.model.Model;
import org.symphonyoss.s2.japigen.parser.log.Logger;

public class RootParserContext// extends ParserContext
{
  private Logger log_;

  private final String          inputSource_;
  private final String          inputSourceName_;
  private InputStream           inputStream_;
  private int                   errorCnt_;
  private URL                   url_;
  private ModelSetParserContext modelSetParserContext_;

  public RootParserContext(ModelSetParserContext modelSetParserContext, URL url) throws ParsingException
  {
    log_ = modelSetParserContext.getLogFactory().getLogger(RootParserContext.class);
    try
    {
      modelSetParserContext_ = modelSetParserContext;
      url_ = url;
      inputStream_ = url.openStream();
      inputSource_ = url.toString();
      
      String path = url_.getPath();
      
      if(path == null || path.length()==0 || "/".equals(path))
      {
        inputSourceName_ = url_.getHost();
      }
      else
      {
        int i = path.lastIndexOf('/');
        
        if(i != -1)
          path = path.substring(i+1);
        
        if(path.length() > 5)
        {
          int l = path.length()-5;
          
          if(".json".equalsIgnoreCase(path.substring(l)))
            path = path.substring(0, l);
        }
        
        inputSourceName_ = path;
      }
    }
    catch(IOException e)
    {
      throw new ParsingException(e);
    }
  }
  
  public RootParserContext(File inputFile, InputStream inputStream)
  {
    inputStream_ = inputStream;
    inputSource_ = inputFile.getAbsolutePath();
    inputSourceName_ = inputFile.getName();
    try
    {
      url_ = inputFile.toURI().toURL();
    }
    catch (MalformedURLException e)
    {
      throw new CodingFault(e);
    }
  }
  
  public URL getUrl()
  {
    return url_;
  }

  public InputStream getInputStream()
  {
    return inputStream_;
  }

  public String getInputSource()
  {
    return inputSource_;
  }
  
  public String getInputSourceName()
  {
    return inputSourceName_;
  }

  public void error(String format, Object ...args)
  {
    log_.errorf(format, args);
    errorCnt_++;
  }
  
  public void epilogue(String action)
  {
    if(errorCnt_ == 0)
      log_.infof("%s of %s completed OK.", action, getInputSource());
    else
      log_.errorf("%s of %s completed with %d errors.", action, getInputSource(), errorCnt_);
  }
  
  public void prologue()
  {
    log_.infof("Parsing %s...", getInputSource());
  }

  public void addReferencedModel(URI uri, ParserContext context) throws ParsingException
  {
    try
    {
      URL url = uri.isAbsolute()
        ? uri.toURL()
        : new URL(url_, uri.toString());
        
        modelSetParserContext_.addReferencedModel(url);
    }
    catch (IOException e)
    {
      context.error("Invalid URI \"%s\" (%s)", uri, e.getMessage());
    }
  }
  
  public Model getModel(URI uri)
  {
    
    try
    {
      URL url = uri.isAbsolute()
        ? uri.toURL()
        : new URL(url_, uri.toString());
        
        return modelSetParserContext_.getModel(url);
    }
    catch (MalformedURLException e)
    {
      throw new ProgramFault(e);
    }
  }
  
  public boolean  hasErrors()
  {
    return errorCnt_ > 0;
  }
}
