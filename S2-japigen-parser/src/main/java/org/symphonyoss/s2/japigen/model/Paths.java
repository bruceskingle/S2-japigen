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

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.symphonyoss.s2.japigen.parser.ParserContext;

public class Paths extends ModelElement
{
  private static Logger log_ = LoggerFactory.getLogger(Paths.class);

  public Paths(Model model, ParserContext parserContext)
  {
    super(model, parserContext, "Paths");
    
    for(ParserContext path : parserContext)
    {
      log_.debug("Found path \"" + path.getName() + "\" at " + path.getPath());
      
      PathItem pathSchema = PathItem.create(this, path);
      
      add(pathSchema.getName(), pathSchema);
    }
  }

  @Override
  public String toString()
  {
    return "Paths";
  }

}