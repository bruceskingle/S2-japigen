/*
 *
 *
 * Copyright 2018 Symphony Communication Services, LLC.
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

package com.symphony.s2.japigen.runtime.http.client;

import com.symphony.s2.japigen.runtime.IModelRegistry;

public class HttpModelClient
{
  private final IModelRegistry registry_;
  private final String         uri_;
  
  public HttpModelClient(IModelRegistry registry, String baseUri, String basePath)
  {
    if(baseUri.endsWith("/"))
      throw new IllegalArgumentException("baseUri must not end with a slash");

    if(!basePath.startsWith("/"))
      throw new IllegalArgumentException("basePath must start with a slash");
    
    registry_ = registry;
    uri_ = baseUri + basePath;
  }

  public String getUri()
  {
    return uri_;
  }

  public IModelRegistry getRegistry()
  {
    return registry_;
  }
}
