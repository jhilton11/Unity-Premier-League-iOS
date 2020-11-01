/*
 *
 * Copyright 2015 gRPC authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

#ifndef GRPC_CORE_EXT_FILTERS_CLIENT_CHANNEL_LB_POLICY_FACTORY_H
#define GRPC_CORE_EXT_FILTERS_CLIENT_CHANNEL_LB_POLICY_FACTORY_H

#include <grpc/support/port_platform.h>

#include "src/core/lib/iomgr/resolve_address.h"

#include "src/core/ext/filters/client_channel/client_channel_factory.h"
#include "src/core/ext/filters/client_channel/lb_policy.h"
#include "src/core/ext/filters/client_channel/uri_parser.h"

//
// representation of an LB address
//

// Channel arg key for grpc_lb_addresses.
#define GRPC_ARG_LB_ADDRESSES "grpc.lb_addresses"

/** A resolved address alongside any LB related information associated with it.
 * \a user_data, if not NULL, contains opaque data meant to be consumed by the
 * gRPC LB policy. Note that no all LB policies support \a user_data as input.
 * Those who don't will simply ignore it and will correspondingly return NULL in
 * their namesake pick() output argument. */
// TODO(roth): Once we figure out a better way of handling user_data in
// LB policies, convert these structs to C++ classes.
typedef struct grpc_lb_address {
  grpc_resolved_address address;
  bool is_balancer;
  char* balancer_name; /* For secure naming. */
  void* user_data;
} grpc_lb_address;

typedef struct grpc_lb_user_data_vtable {
  void* (*copy)(void*);
  void (*destroy)(void*);
  int (*cmp)(void*, void*);
} grpc_lb_user_data_vtable;

typedef struct grpc_lb_addresses {
  size_t num_addresses;
  grpc_lb_address* addresses;
  const grpc_lb_user_data_vtable* user_data_vtable;
} grpc_lb_addresses;

/** Returns a grpc_addresses struct with enough space for
    \a num_addresses addresses.  The \a user_data_vtable argument may be
    NULL if no user data will be added. */
grpc_lb_addresses* grpc_lb_addresses_create(
    size_t num_addresses, const grpc_lb_user_data_vtable* user_data_vtable);

/** Creates a copy of \a addresses. */
grpc_lb_addresses* grpc_lb_addresses_copy(const grpc_lb_addresses* addresses);

/** Sets the value of the address at index \a index of \a addresses.
 * \a address is a socket address of length \a address_len. */
void grpc_lb_addresses_set_address(grpc_lb_addresses* addresses, size_t index,
                                   const void* address, size_t address_len,
                                   bool is_balancer, const char* balancer_name,
                                   void* user_data);

/** Sets the value of the address at index \a index of \a addresses from \a uri.
 * Returns true upon success, false otherwise. */
bool grpc_lb_addresses_set_address_from_uri(grpc_lb_addresses* addresses,
                                            size_t index, const grpc_uri* uri,
                                            bool is_balancer,
                                            const char* balancer_name,
                                            void* user_data);

/** Compares \a addresses1 and \a addresses2. */
int grpc_lb_addresses_cmp(const grpc_lb_addresses* addresses1,
                          const grpc_lb_addresses* addresses2);

/** Destroys \a addresses. */
void grpc_lb_addresses_destroy(grpc_lb_addresses* addresses);

/** Returns a channel arg containing \a addresses. */
grpc_arg grpc_lb_addresses_create_channel_arg(
    const grpc_lb_addresses* addresses);

/** Returns the \a grpc_lb_addresses instance in \a channel_args or NULL */
grpc_lb_addresses* grpc_lb_addresses_find_channel_arg(
    const grpc_channel_args* channel_args);

// Returns true if addresses contains at least one balancer address.
bool grpc_lb_addresses_contains_balancer_address(
    const grpc_lb_addresses& addresses);

//
// LB policy factory
//

namespace grpc_core {

class LoadBalancingPolicyFactory {
 public:
  /// Returns a new LB policy instance.
  virtual OrphanablePtr<LoadBalancingPolicy> CreateLoadBalancingPolicy(
      const LoadBalancingPolicy::Args& args) const GRPC_ABSTRACT;

  /// Returns the LB policy name that this factory provides.
  /// Caller does NOT take ownership of result.
  virtual const char* name() const GRPC_ABSTRACT;

  virtual ~LoadBalancingPolicyFactory() {}

  GRPC_ABSTRACT_BASE_CLASS
};

}  // namespace grpc_core

#endif /* GRPC_CORE_EXT_FILTERS_CLIENT_CHANNEL_LB_POLICY_FACTORY_H */
