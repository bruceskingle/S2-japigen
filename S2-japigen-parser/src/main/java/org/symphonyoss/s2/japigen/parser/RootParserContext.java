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
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URI;
import java.net.URL;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.symphonyoss.s2.common.fault.CodingFault;
import org.symphonyoss.s2.common.fault.ProgramFault;
import org.symphonyoss.s2.japigen.model.Model;

public class RootParserContext// extends ParserContext
{
  private static Logger log_ = LoggerFactory.getLogger(RootParserContext.class);

  private final String          inputSource_;
  private InputStream           inputStream_;
  private int                   errorCnt_;
  private URL                   url_;
  private ModelSetParserContext modelSetParserContext_;

  public RootParserContext(ModelSetParserContext modelSetParserContext, URL url) throws IOException
  {
    modelSetParserContext_ = modelSetParserContext;
    url_ = url;
    inputStream_ = url.openStream();
    inputSource_ = url.toString();
  }
  
  public RootParserContext(File inputFile, InputStream inputStream)
  {
    inputStream_ = inputStream;
    inputSource_ = inputFile.getAbsolutePath();
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
  
  public void error(String format, Object ...args)
  {
    log_.error(format, args);
    errorCnt_++;
  }
  
  public void epilogue(String action)
  {
    if(errorCnt_ == 0)
      log_.info("{} of {} completed OK.", action, getInputSource());
    else
      log_.error("{} of {} completed with {} errors.", action, getInputSource(), errorCnt_);
  }
  
  public void prologue()
  {
    log_.info("Parsing {}...", getInputSource());
  }

  public void addReferencedModel(URI uri, ParserContext context)
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
}
