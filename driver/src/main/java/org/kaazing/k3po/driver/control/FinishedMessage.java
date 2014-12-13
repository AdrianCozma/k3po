/*
 * Copyright (c) 2014 "Kaazing Corporation," (www.kaazing.com)
 *
 * This file is part of Robot.
 *
 * Robot is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

package org.kaazing.k3po.driver.control;

import java.util.Objects;

public class FinishedMessage extends ControlMessage {

    private String script = "";

    public String getScript() {
        return script;
    }

    public void setScript(String script) {
        this.script = script;
    }

    @Override
    public int hashCode() {
        return Objects.hash(getKind(), script);
    }

    @Override
    public boolean equals(Object obj) {
        return (this == obj) || (obj instanceof FinishedMessage) && equals((FinishedMessage) obj);
    }

    @Override
    public Kind getKind() {
        return Kind.FINISHED;
    }

    protected final boolean equals(FinishedMessage that) {
        return super.equalTo(that) && Objects.equals(this.script, that.script);
    }

}