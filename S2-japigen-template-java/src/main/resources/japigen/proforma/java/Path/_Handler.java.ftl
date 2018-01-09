<#include "../S2-japigen-proforma-java-Prologue.ftl">
<@setPrologueJavaType model/>
import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.annotation.concurrent.Immutable;

import com.symphony.s2.japigen.runtime.exception.NoSuchRecordException;
import com.symphony.s2.japigen.runtime.exception.PermissionDeniedException;
import com.symphony.s2.japigen.runtime.exception.ServerErrorException;

<@importFieldTypes model true/>

import ${javaGenPackage}.${modelJavaClassName}ModelHandler;

<#include "../../../template/java/Path/Path.ftl">
@Immutable
public class ${modelJavaClassName}Handler extends ${modelJavaClassName}ModelHandler
{
 <#list model.operations as operation>
 	<@setJavaMethod operation/>
  @Override
  public ${methodReturnType} handle${operation.camelCapitalizedName}(
  <#list operation.parameters as name, parameter>
    <@setJavaType parameter.schema/>
    <#if parameter.isRequired>
    @Nonnull  ${javaClassName?right_pad(25)} ${parameter.camelName}<#sep>,
    <#else>
    @Nullable ${javaClassName?right_pad(25)} ${parameter.camelName}<#sep>,
    </#if>
  </#list>

  )
  ${methodThrows}
  	{
  	   // TODO Auto-generated method stub
    ${methodReturnPlaceholder}
	}

 </#list>
}
<#include "../S2-japigen-proforma-java-Epilogue.ftl">