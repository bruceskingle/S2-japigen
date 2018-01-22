<#include "../S2-japigen-template-java-Prologue.ftl">
import org.symphonyoss.s2.common.exception.BadFormatException;

import org.symphonyoss.s2.common.dom.json.ImmutableJsonObject;

import com.symphony.s2.japigen.runtime.IModel;
import com.symphony.s2.japigen.runtime.ModelObject;

<#list model.schemas as object>
import ${javaFacadePackage}.${object.camelCapitalizedName};
</#list>

public interface I${model.camelCapitalizedName}Model extends IModel
{
<#list model.schemas as object>
  ${object.camelCapitalizedName}.Factory get${object.camelCapitalizedName}Factory();
</#list>
}
<#include "../S2-japigen-template-java-Epilogue.ftl">