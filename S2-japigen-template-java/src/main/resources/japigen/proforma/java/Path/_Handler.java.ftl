<#include "../S2-japigen-proforma-java-Prologue.ftl">
<@setPrologueJavaType model/>
import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.annotation.concurrent.Immutable;

import com.symphony.s2.japigen.runtime.exception.JapiException;
import com.symphony.s2.japigen.runtime.exception.NotImplementedException;

<@importFieldTypes model true/>

import ${javaGenPackage}.${modelJavaClassName}ModelHandler;

<#include "../../../template/java/Path/Path.ftl">
@Immutable
public class ${modelJavaClassName}Handler extends ${modelJavaClassName}ModelHandler
{
  public ${modelJavaClassName}Handler(I${model.model.camelCapitalizedName} model)
  {
    super(model);
  }
  
 <#list model.operations as operation>
 	<@setJavaMethod operation/>
  @Override
  public ${methodReturnType} handle${operation.camelCapitalizedName}(
  <#if operation.payload??>
    <@setJavaType operation.payload.schema/>
    <#if operation.payload.isRequired>
    @Nonnull  ${javaClassName?right_pad(25)} _payload<#if operation.parameters?size != 0>,</#if>
    <#else>
    @Nullable ${javaClassName?right_pad(25)} _payload<#if operation.parameters?size != 0>,</#if>
    </#if>
  </#if>
  <#list operation.parameters as parameter>
    <@setJavaType parameter.schema/>
    <#if parameter.isRequired>
    @Nonnull  ${javaClassName?right_pad(25)} ${parameter.camelName}<#sep>,
    <#else>
    @Nullable ${javaClassName?right_pad(25)} ${parameter.camelName}<#sep>,
    </#if>
  </#list>

  )
  throws JapiException
  	{
  	  throw new NotImplementedException();
	}

 </#list>
}
<#include "../S2-japigen-proforma-java-Epilogue.ftl">