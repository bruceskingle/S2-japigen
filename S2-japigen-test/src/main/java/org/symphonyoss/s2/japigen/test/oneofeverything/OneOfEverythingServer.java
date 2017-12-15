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

package org.symphonyoss.s2.japigen.test.oneofeverything;

import java.io.IOException;

import com.symphony.s2.japigen.runtime.AbstractServer;
import com.symphony.s2.japigen.runtime.IModelRegistry;
import com.symphony.s2.japigen.test.oneofeverything.facade.OneOfEverythingFactory;

public class OneOfEverythingServer extends AbstractServer
{
  private OneOfEverythingFactory  modelFactory_ = new OneOfEverythingFactory();
  
  @Override
  public void registerModels(IModelRegistry registry)
  {
    registry.register(modelFactory_);
  }

  public static void main(String[] argv) throws IOException
  {
    OneOfEverythingServer server = new OneOfEverythingServer();
    
    server.start();
    
    System.out.println("Server started, press RETURN to terminate");
    System.in.read();
    
    System.out.println("Stopping...");
    
    server.stop();
    
    System.out.println("Finished.");
  }
}
