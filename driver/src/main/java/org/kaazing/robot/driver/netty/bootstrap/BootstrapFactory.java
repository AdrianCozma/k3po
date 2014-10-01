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

package org.kaazing.robot.driver.netty.bootstrap;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.ServiceLoader;

import org.kaazing.robot.driver.executor.ExecutorServiceFactory;
import org.kaazing.robot.driver.netty.bootstrap.spi.BootstrapFactorySpi;

public final class BootstrapFactory {
    private final Map<String, BootstrapFactorySpi> bootstrapFactories;

    private BootstrapFactory(Map<String, BootstrapFactorySpi> bootstrapFactories) {
        this.bootstrapFactories = Collections.unmodifiableMap(bootstrapFactories);
    }

    public static BootstrapFactory newBootstrapFactory() {
        Map<Class<?>, Object> injectables = new HashMap<>();
        injectables.put(ExecutorServiceFactory.class, ExecutorServiceFactory.newInstance());
        return newBootstrapFactory(injectables);
    }

    public static BootstrapFactory newBootstrapFactory(Map<Class<?>, Object> injectables) {
        ServiceLoader<BootstrapFactorySpi> loader = loadBootstrapFactorySpi();

        // load BootstrapFactorySpi instances
        Map<String, BootstrapFactorySpi> bootstrapFactories = new HashMap<>();
        for (BootstrapFactorySpi bootstrapFactorySpi : loader) {
            String transportName = bootstrapFactorySpi.getTransportName();
            BootstrapFactorySpi oldBootstrapFactorySpi = bootstrapFactories.put(transportName,
                    bootstrapFactorySpi);
            if (oldBootstrapFactorySpi != null) {
                throw new BootstrapException(String.format("Duplicate transport bootstrap factory: %s", transportName));
            }
        }

        // inject resources into BootstrapFactorySpi instances
        BootstrapFactory bootstrapFactory = new BootstrapFactory(bootstrapFactories);
        for (BootstrapFactorySpi bootstrapFactorySpi : bootstrapFactories.values()) {
            Utils.inject(bootstrapFactorySpi, BootstrapFactory.class, bootstrapFactory);
            Utils.injectAll(bootstrapFactorySpi, injectables);
        }

        return bootstrapFactory;
    }

    public ServerBootstrap newServerBootstrap(String transportName) throws Exception {

        BootstrapFactorySpi bootstrapFactory = findBootstrapFactory(transportName);
        return bootstrapFactory.newServerBootstrap();
    }

    public ClientBootstrap newClientBootstrap(String transportName) throws Exception {

        BootstrapFactorySpi bootstrapFactory = findBootstrapFactory(transportName);
        return bootstrapFactory.newClientBootstrap();
    }

    private static ServiceLoader<BootstrapFactorySpi> loadBootstrapFactorySpi() {
        return ServiceLoader.load(BootstrapFactorySpi.class);
    }

    private BootstrapFactorySpi findBootstrapFactory(String transportName) throws BootstrapException {

        if (transportName == null) {
            throw new NullPointerException("transportName");
        }

        BootstrapFactorySpi bootstrapFactory = bootstrapFactories.get(transportName);
        if (bootstrapFactory == null) {
            throw new BootstrapException(String.format("Unable to load transport: %s", transportName));
        }

        return bootstrapFactory;
    }
}
