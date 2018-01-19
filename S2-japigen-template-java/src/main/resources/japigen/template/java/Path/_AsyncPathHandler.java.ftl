<#include "../S2-japigen-template-java-Prologue.ftl">
<@setPrologueJavaType model/>
import java.io.IOException;
import java.io.StringReader;

import java.util.Iterator;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.concurrent.ExecutorService;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.annotation.concurrent.Immutable;

import javax.servlet.AsyncContext;
import javax.servlet.ServletInputStream;
import javax.servlet.ServletOutputStream;

import org.symphonyoss.s2.common.dom.json.ImmutableJsonObject;
import org.symphonyoss.s2.common.dom.json.JsonValue;
import org.symphonyoss.s2.common.exception.BadFormatException;

import com.symphony.s2.japigen.runtime.AsyncPathHandler;
import com.symphony.s2.japigen.runtime.IConsumer;
import com.symphony.s2.japigen.runtime.PayloadResponseRequestManager;
import com.symphony.s2.japigen.runtime.ModelRegistry;
import com.symphony.s2.japigen.runtime.exception.BadRequestException;
import com.symphony.s2.japigen.runtime.exception.JapiException;
import com.symphony.s2.japigen.runtime.exception.NoSuchRecordException;
import com.symphony.s2.japigen.runtime.exception.PermissionDeniedException;
import com.symphony.s2.japigen.runtime.exception.ServerErrorException;
import com.symphony.s2.japigen.runtime.http.ParameterLocation;
import com.symphony.s2.japigen.runtime.http.RequestContext;



<@importFieldTypes model true/>

import ${javaFacadePackage}.I${model.model.camelCapitalizedName};

<#include "Path.ftl">
@Immutable
public abstract class ${modelJavaClassName}AsyncPathHandler extends AsyncPathHandler<I${model.model.camelCapitalizedName}> implements I${modelJavaClassName}AsyncPathHandler
{
  public ${modelJavaClassName}AsyncPathHandler(I${model.model.camelCapitalizedName} model,
    ExecutorService processExecutor,
    ExecutorService responseExecutor)
  {
    super(model, processExecutor, responseExecutor, ${model.pathParamCnt}, new String[] {
<#list model.partList as part>
        "${part}"<#sep>,
</#list>
      }
    );
  }

  @Override
  public String getPath()
  {
    return "${model.absolutePath}";
  }

  @Override
  public void handle(RequestContext context, List<String> pathParams) throws IOException, JapiException
  {
    switch(context.getMethod())
    {
<#if model.unsupportedOperations?size != 0>
  <#list model.unsupportedOperations as operation>
      case ${operation}:
  </#list>
        unsupportedMethod(context);
        break;
        
</#if>
<#list model.operations as operation>
  <@setJavaMethod operation/>
      case ${operation.camelCapitalizedName}:
        do${operation.camelCapitalizedName}(context, pathParams);
        break;
        
</#list>
    }
  }
<#list model.operations as operation>
  <@setJavaMethod operation/>
  
  private void do${operation.camelCapitalizedName}(RequestContext context, List<String> pathParams) throws IOException, JapiException
  {
    Iterator<String> it = pathParams.iterator();
  <#list operation.pathParameters as parameter>
  <@setJavaType parameter.schema/>

    // We have already checked that there are the correct number of parameters
      
    ${javaFieldClassName?right_pad(25)} ${parameter.camelName}Value = context.as${javaFieldClassName}("${parameter.name}", it.next());
    ${javaClassName?right_pad(25)} ${parameter.camelName} = null;

    <#if requiresChecks>
    <@checkLimits "    " parameter parameter.camelName/>
    </#if>
    
    <#if checkLimitsClass(parameter.schema)>
    try
    {
      ${parameter.camelName} = ${javaConstructTypePrefix}${parameter.camelName}Value${javaConstructTypePostfix};
    }
    catch(BadFormatException e)
    {
      context.error("Parameter \"${parameter.camelName}\" has invalid value \"%s\" (%s)", ${parameter.camelName}Value, e.getMessage());
    }
    <#else>
    ${parameter.camelName} = ${javaConstructTypePrefix}${parameter.camelName}Value${javaConstructTypePostfix};
    </#if>
    
    
  </#list>
  
  <#list operation.nonPathParameters as parameter>
  <@setJavaType parameter.schema/>

    ${javaFieldClassName?right_pad(25)} ${parameter.camelName}Value = context.getParameterAs${javaFieldClassName}("${parameter.name}", ParameterLocation.${parameter.location}, ${parameter.isRequired?c});
    ${javaClassName?right_pad(25)} ${parameter.camelName} = null; 
    
    if(${parameter.camelName}Value != null)
    {
    <#if checkLimitsClass(parameter.schema)>
      try
      {
        ${parameter.camelName} = ${javaConstructTypePrefix}${parameter.camelName}Value${javaConstructTypePostfix};
      }
      catch(BadFormatException e)
      {
        context.error("Parameter \"${parameter.camelName}\" has invalid value \"%s\" (%s)", ${parameter.camelName}Value, e.getMessage());
      }
    <#else>
      ${parameter.camelName} = ${javaConstructTypePrefix}${parameter.camelName}Value${javaConstructTypePostfix};
    </#if>
    }

    <#if requiresChecks>
    <@checkLimits "    " parameter parameter.camelName/>
    </#if>
  </#list>
  
    if(context.preConditionsAreMet())
    {
        ServletInputStream in = context.getRequest().getInputStream();
        ServletOutputStream out = context.getResponse().getOutputStream();
        AsyncContext async=context.getRequest().startAsync();

        PayloadResponseRequestManager<${methodPayloadType}, ${methodResponseType}> manager =
          new PayloadResponseRequestManager<${methodPayloadType}, ${methodResponseType}>(in, out, async, getProcessExecutor(), getResponseExecutor())
        {
          @Override
          public void handle(${methodPayloadDecl} payload, IConsumer<${methodResponseType}> consumer) throws JapiException
          {
            handlePost(payload, consumer);
          }
<#if operation.payload??>
  <@setJavaType operation.payload.schema/>
  
          @Override
          protected ${methodPayloadType} parsePayload(String request) throws BadFormatException
          {
  <#if operation.payload.schema.isTypeDef>
              JsonValue<?, ?> jsonValue = ModelRegistry.parseOneJsonValue(new StringReader(request));
              return ${javaClassName}.newBuilder().build(jsonValue);
  <#else>
              ImmutableJsonObject jsonObject = ModelRegistry.parseOneJsonObject(new StringReader(request));
              return getModel().get${javaClassName}Factory().newInstance(jsonObject);
  </#if>
          }
         
<#else>
  <@setJavaType operation.response.schema/>
  /*          
          @Override
          protected ${javaClassName} handle${operation.camelCapitalizedName}()
          {
              return handle${operation.camelCapitalizedName}();
          }
          */
</#if>
        };
        
        out.setWriteListener(manager);
        in.setReadListener(manager);
        System.err.println("isReady=" + in.isReady());
  
  <#--     
  <#switch methodStyle>
    <#case "PayloadResponse">
      handleWithPayloadResponse(context, pathParams, handler);
      <#break>
     
     <#case "Payload">
      handleWithPayload(context, pathParams);
      <#break>
     
     <#case "Response">
      handleWithResponse(context, pathParams);
      <#break>
    
    <#default>
      handle(context, pathParams);
  </#switch>
  ---->
    }
  }
  



</#list>

}
<#include "../S2-japigen-template-java-Epilogue.ftl">