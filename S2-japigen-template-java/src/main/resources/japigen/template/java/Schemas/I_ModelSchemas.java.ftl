<#include "../S2-japigen-template-java-Prologue.ftl">
import org.symphonyoss.s2.common.exception.BadFormatException;

import org.symphonyoss.s2.common.dom.json.ImmutableJsonObject;

import com.symphony.s2.japigen.runtime.IModelSchemas;
import com.symphony.s2.japigen.runtime.ModelObject;

public interface I${model.camelCapitalizedName}ModelSchemas extends IModelSchemas
{
  ModelObject create(ImmutableJsonObject jsonObject) throws BadFormatException;
}
<#include "../S2-japigen-template-java-Epilogue.ftl">