/**
 * Copyright 2007-2015, Kaazing Corporation. All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.kaazing.k3po.driver.internal.behavior;

import static java.util.Objects.requireNonNull;

import org.kaazing.k3po.lang.internal.RegionInfo;

@SuppressWarnings("serial")
public class ScriptProgressException extends Exception {

    private final RegionInfo regionInfo;

    public ScriptProgressException(RegionInfo regionInfo, String message) {
        super(message);
        this.regionInfo = requireNonNull(regionInfo);
    }

    public RegionInfo getRegionInfo() {
        return regionInfo;
    }
}
