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

public class DoubleType extends Type
{
  private final double defaultMinimum_;
  private final double defaultMaximum_;
  private final double minimum_;
  private final double maximum_;
  
  public DoubleType(ModelElement parent, ParserContext context)
  {
    super(parent, context, "Double");
    
    
    switch(getFormat())
    {
      case "float":
        defaultMinimum_ = Float.MIN_VALUE;
        defaultMaximum_ = Float.MAX_VALUE;
        break;
        
      case "double":
        defaultMinimum_ = Double.MIN_VALUE;
        defaultMaximum_ = Double.MAX_VALUE;
        break;
        
      case "":
        defaultMinimum_ = Double.MIN_VALUE;
        defaultMaximum_ = Double.MAX_VALUE;
        break;
        
      default:
        defaultMinimum_ = Double.MIN_VALUE;
        defaultMaximum_ = Double.MAX_VALUE;
        context.error("Unknown format \"%s\"", getFormat());
    }
    
    minimum_ = context.getDoubleNode("minimum", defaultMinimum_);
    maximum_ = context.getDoubleNode("minimum", defaultMaximum_);
  }

  public double getMinimum()
  {
    return minimum_;
  }

  public double getMaximum()
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
