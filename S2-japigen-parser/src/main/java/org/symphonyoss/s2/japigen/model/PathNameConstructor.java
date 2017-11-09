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

import java.io.File;
import java.util.Map;

public class PathNameConstructor implements IPathNameConstructor
{
  @Override
  public String constructFile(Map<String, Object> dataModel, String language, String templateName,
      ModelElement modelElement)
  {
    return constructFile(language, null, templateName, modelElement.getName());
  }

  public String constructFile(String language, Object directoryPath, String templateName,
      String modelElementName)
  {
    int     underscoreIndex = templateName.indexOf('_');
    
    if(underscoreIndex == -1)
      return null;
    
    StringBuilder s = null;
    
    if(language != null)
    {
      s = new StringBuilder();
      
      s.append(language);
    }
    
    if(directoryPath != null)
    {
      if(s==null)
        s = new StringBuilder();
      else
        s.append(File.separatorChar);
      
      s.append(directoryPath);
    }
    
    if(s==null)
      s = new StringBuilder();
    else
      s.append(File.separatorChar);
    
    int     len = templateName.endsWith(".ftl") ? templateName.length() - 4 : templateName.length();
    int     i = 0;
    
    while(i<underscoreIndex)
    {
      s.append(templateName.charAt(i++));
    }
    
    i++; // skip the underscore
    
    s.append(modelElementName);
    
    while(i<len)
    {
      s.append(templateName.charAt(i++));
    }
    
    return s.toString();
  }
}
