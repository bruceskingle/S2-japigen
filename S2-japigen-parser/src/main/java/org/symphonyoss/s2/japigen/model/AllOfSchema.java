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

import java.util.ArrayList;
import java.util.List;

import org.symphonyoss.s2.japigen.parser.ParserContext;

public class AllOfSchema extends AbstractContainerSchema
{
  private ParserContext discriminator_;
  private List<ModelElement>  fields_;

  public AllOfSchema(ModelElement parent, ParserContext context, ParserContext node)
  {
    super(parent, context, node, "AllOf");
  }

  public ParserContext getDiscriminator()
  {
    return discriminator_;
  }

  public synchronized List<ModelElement> getFields()
  {
    if(fields_ == null)
    {
      fields_ = new ArrayList<>();
      
      for(ModelElement e : getChildren())
      {
        if(e instanceof ObjectSchema)
        {
          for(ModelElement child : e.getChildren())
            fields_.add(child);
        }
        else
        {
          fields_.add(e);
        }
      }
    }
    return fields_;
  }
  
}
