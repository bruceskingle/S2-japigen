package com.symphony.s2.japigen.runtime;

import java.util.concurrent.ExecutorService;

import javax.servlet.AsyncContext;
import javax.servlet.ServletInputStream;
import javax.servlet.ServletOutputStream;
import javax.servlet.WriteListener;

import com.symphony.s2.japigen.runtime.exception.JapiException;

public abstract class ResponseOnlyRequestManager<R extends IModelEntity>
extends AbstractRequestManager<Void,R>
implements WriteListener, IResponseOnlyRequestManager<R>
{

  public ResponseOnlyRequestManager(ServletInputStream in, ServletOutputStream out, AsyncContext async,
      ExecutorService processExecutor, ExecutorService responseExecutor)
  {
    super(in, out, async, processExecutor, responseExecutor);
  }

  @Override
  protected void handleRequest(String request) throws JapiException
  {
    handle(getResponseTask());
  }

  @Override
  protected void finishRequest()
  {
    System.err.println("Request finish()");
    getResponseTask().close();
  }
  
  public void start()
  {
    getProcessTask().consume("");
  }
}