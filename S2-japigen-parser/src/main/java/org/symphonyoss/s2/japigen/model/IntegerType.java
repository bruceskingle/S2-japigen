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

package org.symphonyoss.s2.japigen.model;

import org.symphonyoss.s2.japigen.parser.ParserContext;

public class IntegerType extends Type
{
  private final long defaultMinimum_;
  private final long defaultMaximum_;
  private final long minimum_;
  private final long maximum_;
  
  public IntegerType(Model model, ParserContext context)
  {
    super(model, context, "Integer");
    
    
    switch(getFormat())
    {
      case "int32":
        defaultMinimum_ = Integer.MIN_VALUE;
        defaultMaximum_ = Integer.MAX_VALUE;
        break;
        
      case "int64":
        defaultMinimum_ = Long.MIN_VALUE;
        defaultMaximum_ = Long.MAX_VALUE;
        break;
        
      case "":
        defaultMinimum_ = Long.MIN_VALUE;
        defaultMaximum_ = Long.MAX_VALUE;
        break;
        
      default:
        defaultMinimum_ = Long.MIN_VALUE;
        defaultMaximum_ = Long.MAX_VALUE;
        context.error("Unknown format \"%s\"", getFormat());
    }
    
    minimum_ = context.getLongNode("minimum", defaultMinimum_);
    maximum_ = context.getLongNode("minimum", defaultMaximum_);
  }

  public long getMinimum()
  {
    return minimum_;
  }

  public long getMaximum()
  {
    return maximum_;
  }

  @Override
  public String toString()
  {
    return super.toString(new ValueMap<String, Object>()
        .append("minimum", minimum_, defaultMinimum_)
        .append("maximum", maximum_, defaultMaximum_));
  }
}
