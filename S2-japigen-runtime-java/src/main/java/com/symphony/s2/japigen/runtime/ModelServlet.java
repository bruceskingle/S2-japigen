/*
 * Copyright 2018 Symphony Communication Services, LLC.
 *
 * All Rights Reserved
 */

package com.symphony.s2.japigen.runtime;

import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public abstract class ModelServlet extends HttpServlet implements IModelServlet
{
  private static final long serialVersionUID = 1L;

  
  /**
   * Called by generated servlets for unsupported methods.
   * 
   * @param req           Servlet request
   * @param resp          Servlet response
   * @param methodName    Name of method called.
   * @throws IOException  If the response cannot be sent.
   */
  public void unsupportedOperation(HttpServletRequest req, HttpServletResponse resp, String methodName) throws IOException
  {
    resp.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "Method \"" + methodName + "\" is not supported.");
  }
}
