// Author: Jin Qing (http://blog.csdn.net/jq0123)
#ifndef SERVER_SERVER_READER_H
#define SERVER_SERVER_READER_H

#include <grpc_cb_core/server/server_reader.h>  // for grpc_cb_core::ServerReader

#include "common/LuaRefFwd.h"  // forward LuaRef

#include <string>

namespace impl {

class Status;

// ServerReader is the interface of client streaming handler,
//  for both client-side streaming and bi-directional streaming.
// Thread-safe.
class ServerReader : public grpc_cb_core::ServerReader {
 public:
  using LuaRef = LuaIntf::LuaRef;
  explicit ServerReader(const LuaRef& luaReader);
  virtual ~ServerReader();

 public:
  void OnMsgStr(const std::string& msg_str) GRPC_OVERRIDE;
  void OnError(const Status& status) GRPC_OVERRIDE;
  void OnEnd() GRPC_OVERRIDE;

 private:
  std::unique_ptr<LuaRef> m_pLuaReader;
};  // class ServerReader

}  // namespace impl
#endif  // SERVER_SERVER_READER_H
