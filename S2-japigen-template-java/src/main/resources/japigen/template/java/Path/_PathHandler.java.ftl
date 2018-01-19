<#include "../S2-japigen-template-java-Prologue.ftl">
<@setPrologueJavaType model/>
import javax.annotation.concurrent.Immutable;

import java.io.IOException;

import java.util.Iterator;
import java.util.List;


import org.symphonyoss.s2.common.exception.BadFormatException;

import com.symphony.s2.japigen.runtime.PathHandler;
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
public abstract class ${modelJavaClassName}PathHandler extends PathHandler<I${model.model.camelCapitalizedName}> implements I${modelJavaClassName}PathHandler
{
  public ${modelJavaClassName}PathHandler(I${model.model.camelCapitalizedName} model)
  {
    super(model, ${model.pathParamCnt}, new String[] {
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
      case ${operation.camelCapitalizedName}:
        do${operation.camelCapitalizedName}(context, pathParams);
        break;
        
</#list>
    }
  }
<#list model.operations as operation>

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
  <#if operation.payload??>
  
    <@setJavaType operation.payload.schema/>
    // operation.payload = ${operation.payload.schema}
    <#if operation.payload.schema.isTypeDef>
      // typedef
    ${javaClassName} _payload = context.parsePayload(${javaClassName}.newBuilder());
    <#else>
    ${javaClassName} _payload = context.parsePayload(getModel().get${javaClassName}Factory());
    </#if>
  </#if>
  
    if(context.preConditionsAreMet())
    {
      try
      {
  <#if operation.response??>
    <@setJavaType operation.response.schema/>
        ${javaClassName} response =
  </#if> 
          handle${operation.camelCapitalizedName}(
  <#if operation.payload??>
            _payload<#if operation.parameters?size != 0>,</#if>
  </#if>
  <#list operation.parameters as parameter>
    <@setJavaType parameter.schema/>
            ${parameter.camelName}<#sep>,
  </#list>
  
          );
  <#if operation.response??>
    <@setJavaType operation.response.schema/>
        if(response == null)
        {
    <#if operation.response.isRequired>
          throw new ServerErrorException("Required return value is null");        
    <#else>
          throw new NoSuchRecordException();      
    </#if>
        }
        else
        {
          context.sendOKResponse(response);
        }
  <#else>
        context.sendOKResponse();
  </#if>
      }
  <#if operation.response?? && operation.response.isRequired>
      catch(PermissionDeniedException | ServerErrorException e)
  <#else>
      catch(PermissionDeniedException | ServerErrorException | NoSuchRecordException e)
  </#if>
      {
        throw e;
      }
      catch(JapiException | RuntimeException e)
      {
        throw new ServerErrorException(e);
      }
    }
  }
</#list>


}
<#include "../S2-japigen-template-java-Epilogue.ftl">