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
import java.io.InputStream;

import com.fasterxml.jackson.databind.JsonNode;

public class RootParserContext extends ParserContext
{
  private final File inputFile_;
  private JsonNode rootJsonNode_;
  private InputStream inputStream_;

  public RootParserContext(File inputFile, InputStream inputStream)
  {
    super(null);
    
    inputFile_ = inputFile;
    inputStream_ = inputStream;
  }

  public void setRootJsonNode(JsonNode rootJsonNode)
  {
    rootJsonNode_ = rootJsonNode;
  }
  
  @Override
  public RootParserContext getRootParserContext()
  {
    return this;
  }

  @Override
  public JsonNode getJsonNode()
  {
    return rootJsonNode_;
  }

  public InputStream getInputStream()
  {
    return inputStream_;
  }

  public String getInputSource()
  {
    return inputFile_.getAbsolutePath();
  }
}
