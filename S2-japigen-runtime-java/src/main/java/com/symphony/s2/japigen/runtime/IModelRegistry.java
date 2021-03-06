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

package com.symphony.s2.japigen.runtime;

import java.io.IOException;
import java.io.Reader;
import java.util.Collection;

import org.symphonyoss.s2.common.dom.json.ImmutableJsonObject;
import org.symphonyoss.s2.common.exception.BadFormatException;
import org.symphonyoss.s2.common.http.IUrlPathServlet;

public interface IModelRegistry
{
  IModelRegistry register(IModel factory);

  IModelRegistry register(String name, IModelObjectFactory<?,?> factory);

  IModelObject newInstance(ImmutableJsonObject jsonObject) throws BadFormatException;

  IModelObject parseOne(Reader reader) throws IOException, BadFormatException;
  
  void parseStream(Reader reader, IModelObjectConsumer consumer) throws BadFormatException;
  
  Collection<IUrlPathServlet> getServlets();

  void start();
  
  void stop();

  void register(IUrlPathServlet servlet);
}
