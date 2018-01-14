<#include "../S2-japigen-template-java-Prologue.ftl">
<@setPrologueJavaType model/>

import com.symphony.s2.japigen.runtime.IModelObject;

<#list model.children as field>
import ${javaFacadePackage}.I${field.camelCapitalizedName};
</#list>

<#include "../Object/Object.ftl">
public interface I${model.camelCapitalizedName}ModelObject extends IModelObject,
<#list model.children as field>
  I${field.camelCapitalizedName}<#sep>,
</#list>
 
{
}
<#include "../S2-japigen-template-java-Epilogue.ftl">