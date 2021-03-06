(function() {
  var NodeTypes, ParameterMissing, Utils, defaults,
    __hasProp = {}.hasOwnProperty;

  ParameterMissing = function(message) {
    this.message = message;
  };

  ParameterMissing.prototype = new Error();

  defaults = {
    prefix: "",
    default_url_options: {}
  };

  NodeTypes = {"GROUP":1,"CAT":2,"SYMBOL":3,"OR":4,"STAR":5,"LITERAL":6,"SLASH":7,"DOT":8};

  Utils = {
    serialize: function(object, prefix) {
      var element, i, key, prop, result, s, _i, _len;
      if (prefix == null) {
        prefix = null;
      }
      if (!object) {
        return "";
      }
      if (!prefix && !(this.get_object_type(object) === "object")) {
        throw new Error("Url parameters should be a javascript hash");
      }
      if (window.jQuery) {
        result = window.jQuery.param(object);
        return (!result ? "" : result);
      }
      s = [];
      switch (this.get_object_type(object)) {
        case "array":
          for (i = _i = 0, _len = object.length; _i < _len; i = ++_i) {
            element = object[i];
            s.push(this.serialize(element, prefix + "[]"));
          }
          break;
        case "object":
          for (key in object) {
            if (!__hasProp.call(object, key)) continue;
            prop = object[key];
            if (!(prop != null)) {
              continue;
            }
            if (prefix != null) {
              key = "" + prefix + "[" + key + "]";
            }
            s.push(this.serialize(prop, key));
          }
          break;
        default:
          if (object) {
            s.push("" + (encodeURIComponent(prefix.toString())) + "=" + (encodeURIComponent(object.toString())));
          }
      }
      if (!s.length) {
        return "";
      }
      return s.join("&");
    },
    clean_path: function(path) {
      var last_index;
      path = path.split("://");
      last_index = path.length - 1;
      path[last_index] = path[last_index].replace(/\/+/g, "/").replace(/.\/$/m, "");
      return path.join("://");
    },
    set_default_url_options: function(optional_parts, options) {
      var i, part, _i, _len, _results;
      _results = [];
      for (i = _i = 0, _len = optional_parts.length; _i < _len; i = ++_i) {
        part = optional_parts[i];
        if (!options.hasOwnProperty(part) && defaults.default_url_options.hasOwnProperty(part)) {
          _results.push(options[part] = defaults.default_url_options[part]);
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    },
    extract_anchor: function(options) {
      var anchor;
      anchor = "";
      if (options.hasOwnProperty("anchor")) {
        anchor = "#" + options.anchor;
        delete options.anchor;
      }
      return anchor;
    },
    extract_options: function(number_of_params, args) {
      var ret_value;
      ret_value = {};
      if (args.length > number_of_params) {
        ret_value = args.pop();
      }
      return ret_value;
    },
    path_identifier: function(object) {
      var property;
      if (object === 0) {
        return "0";
      }
      if (!object) {
        return "";
      }
      property = object;
      if (this.get_object_type(object) === "object") {
        property = object.to_param || object.id || object;
        if (this.get_object_type(property) === "function") {
          property = property.call(object);
        }
      }
      return property.toString();
    },
    clone: function(obj) {
      var attr, copy, key;
      if ((obj == null) || "object" !== this.get_object_type(obj)) {
        return obj;
      }
      copy = obj.constructor();
      for (key in obj) {
        if (!__hasProp.call(obj, key)) continue;
        attr = obj[key];
        copy[key] = attr;
      }
      return copy;
    },
    prepare_parameters: function(required_parameters, actual_parameters, options) {
      var i, result, val, _i, _len;
      result = this.clone(options) || {};
      for (i = _i = 0, _len = required_parameters.length; _i < _len; i = ++_i) {
        val = required_parameters[i];
        result[val] = actual_parameters[i];
      }
      return result;
    },
    build_path: function(required_parameters, optional_parts, route, args) {
      var anchor, opts, parameters, result, url, url_params;
      args = Array.prototype.slice.call(args);
      opts = this.extract_options(required_parameters.length, args);
      if (args.length > required_parameters.length) {
        throw new Error("Too many parameters provided for path");
      }
      parameters = this.prepare_parameters(required_parameters, args, opts);
      this.set_default_url_options(optional_parts, parameters);
      anchor = this.extract_anchor(parameters);
      result = "" + (this.get_prefix()) + (this.visit(route, parameters));
      url = Utils.clean_path("" + result);
      if ((url_params = this.serialize(parameters)).length) {
        url += "?" + url_params;
      }
      url += anchor;
      return url;
    },
    visit: function(route, parameters, optional) {
      var left, left_part, right, right_part, type, value;
      if (optional == null) {
        optional = false;
      }
      type = route[0], left = route[1], right = route[2];
      switch (type) {
        case NodeTypes.GROUP:
          return this.visit(left, parameters, true);
        case NodeTypes.STAR:
          return this.visit_globbing(left, parameters, true);
        case NodeTypes.LITERAL:
        case NodeTypes.SLASH:
        case NodeTypes.DOT:
          return left;
        case NodeTypes.CAT:
          left_part = this.visit(left, parameters, optional);
          right_part = this.visit(right, parameters, optional);
          if (optional && !(left_part && right_part)) {
            return "";
          }
          return "" + left_part + right_part;
        case NodeTypes.SYMBOL:
          value = parameters[left];
          if (value != null) {
            delete parameters[left];
            return this.path_identifier(value);
          }
          if (optional) {
            return "";
          } else {
            throw new ParameterMissing("Route parameter missing: " + left);
          }
          break;
        default:
          throw new Error("Unknown Rails node type");
      }
    },
    visit_globbing: function(route, parameters, optional) {
      var left, right, type, value;
      type = route[0], left = route[1], right = route[2];
      if (left.replace(/^\*/i, "") !== left) {
        route[1] = left = left.replace(/^\*/i, "");
      }
      value = parameters[left];
      if (value == null) {
        return this.visit(route, parameters, optional);
      }
      parameters[left] = (function() {
        switch (this.get_object_type(value)) {
          case "array":
            return value.join("/");
          default:
            return value;
        }
      }).call(this);
      return this.visit(route, parameters, optional);
    },
    get_prefix: function() {
      var prefix;
      prefix = defaults.prefix;
      if (prefix !== "") {
        prefix = (prefix.match("/$") ? prefix : "" + prefix + "/");
      }
      return prefix;
    },
    _classToTypeCache: null,
    _classToType: function() {
      var name, _i, _len, _ref;
      if (this._classToTypeCache != null) {
        return this._classToTypeCache;
      }
      this._classToTypeCache = {};
      _ref = "Boolean Number String Function Array Date RegExp Undefined Null".split(" ");
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        name = _ref[_i];
        this._classToTypeCache["[object " + name + "]"] = name.toLowerCase();
      }
      return this._classToTypeCache;
    },
    get_object_type: function(obj) {
      var strType;
      if (window.jQuery && (window.jQuery.type != null)) {
        return window.jQuery.type(obj);
      }
      strType = Object.prototype.toString.call(obj);
      return this._classToType()[strType] || "object";
    },
    namespace: function(root, namespaceString) {
      var current, parts;
      parts = (namespaceString ? namespaceString.split(".") : []);
      if (!parts.length) {
        return;
      }
      current = parts.shift();
      root[current] = root[current] || {};
      return Utils.namespace(root[current], parts.join("."));
    }
  };

  Utils.namespace(window, "ReportIt.routes");

  window.ReportIt.routes = {
// about => /about(.:format)
  about_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[7,"/",false],[6,"about",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// api_v1_accept_invitation => /api/v1/invitations/accept/:id(.:format)
  api_v1_accept_invitation_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[2,[2,[2,[2,[2,[2,[7,"/",false],[6,"api",false]],[7,"/",false]],[6,"v1",false]],[7,"/",false]],[6,"invitations",false]],[7,"/",false]],[6,"accept",false]],[7,"/",false]],[3,"id",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// api_v1_copy_report => /api/v1/reports/copy/:id(.:format)
  api_v1_copy_report_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[2,[2,[2,[2,[2,[2,[7,"/",false],[6,"api",false]],[7,"/",false]],[6,"v1",false]],[7,"/",false]],[6,"reports",false]],[7,"/",false]],[6,"copy",false]],[7,"/",false]],[3,"id",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// api_v1_create_invitation => /api/v1/invitations(.:format)
  api_v1_create_invitation_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"api",false]],[7,"/",false]],[6,"v1",false]],[7,"/",false]],[6,"invitations",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// api_v1_create_report => /api/v1/reports(.:format)
  api_v1_create_report_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"api",false]],[7,"/",false]],[6,"v1",false]],[7,"/",false]],[6,"reports",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// api_v1_create_snippet => /api/v1/snippets(.:format)
  api_v1_create_snippet_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"api",false]],[7,"/",false]],[6,"v1",false]],[7,"/",false]],[6,"snippets",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// api_v1_destroy_association => /api/v1/associates/:id(.:format)
  api_v1_destroy_association_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[2,[2,[2,[2,[7,"/",false],[6,"api",false]],[7,"/",false]],[6,"v1",false]],[7,"/",false]],[6,"associates",false]],[7,"/",false]],[3,"id",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// api_v1_destroy_invitation => /api/v1/invitations/:id(.:format)
  api_v1_destroy_invitation_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[2,[2,[2,[2,[7,"/",false],[6,"api",false]],[7,"/",false]],[6,"v1",false]],[7,"/",false]],[6,"invitations",false]],[7,"/",false]],[3,"id",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// api_v1_destroy_report => /api/v1/reports/:id(.:format)
  api_v1_destroy_report_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[2,[2,[2,[2,[7,"/",false],[6,"api",false]],[7,"/",false]],[6,"v1",false]],[7,"/",false]],[6,"reports",false]],[7,"/",false]],[3,"id",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// api_v1_destroy_snippet => /api/v1/snippets/:id(.:format)
  api_v1_destroy_snippet_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[2,[2,[2,[2,[7,"/",false],[6,"api",false]],[7,"/",false]],[6,"v1",false]],[7,"/",false]],[6,"snippets",false]],[7,"/",false]],[3,"id",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// api_v1_edit_report => /api/v1/reports/edit/:id(.:format)
  api_v1_edit_report_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[2,[2,[2,[2,[2,[2,[7,"/",false],[6,"api",false]],[7,"/",false]],[6,"v1",false]],[7,"/",false]],[6,"reports",false]],[7,"/",false]],[6,"edit",false]],[7,"/",false]],[3,"id",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// api_v1_get_associates => /api/v1/associates(.:format)
  api_v1_get_associates_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"api",false]],[7,"/",false]],[6,"v1",false]],[7,"/",false]],[6,"associates",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// api_v1_get_invitations_by_type => /api/v1/invitations/:type(.:format)
  api_v1_get_invitations_by_type_path: function(_type, options) {
  return Utils.build_path(["type"], ["format"], [2,[2,[2,[2,[2,[2,[2,[2,[7,"/",false],[6,"api",false]],[7,"/",false]],[6,"v1",false]],[7,"/",false]],[6,"invitations",false]],[7,"/",false]],[3,"type",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// api_v1_get_notifications => /api/v1/notifications(.:format)
  api_v1_get_notifications_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"api",false]],[7,"/",false]],[6,"v1",false]],[7,"/",false]],[6,"notifications",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// api_v1_get_potential_associates => /api/v1/potential_associates(.:format)
  api_v1_get_potential_associates_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"api",false]],[7,"/",false]],[6,"v1",false]],[7,"/",false]],[6,"potential_associates",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// api_v1_get_reports => /api/v1/reports(.:format)
  api_v1_get_reports_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"api",false]],[7,"/",false]],[6,"v1",false]],[7,"/",false]],[6,"reports",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// api_v1_get_settings => /api/v1/settings(.:format)
  api_v1_get_settings_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"api",false]],[7,"/",false]],[6,"v1",false]],[7,"/",false]],[6,"settings",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// api_v1_get_shared_reports_by_associate => /api/v1/associate/:id/shares(.:format)
  api_v1_get_shared_reports_by_associate_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[2,[2,[2,[2,[2,[2,[7,"/",false],[6,"api",false]],[7,"/",false]],[6,"v1",false]],[7,"/",false]],[6,"associate",false]],[7,"/",false]],[3,"id",false]],[7,"/",false]],[6,"shares",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// api_v1_get_shares => /api/v1/shares/:id(.:format)
  api_v1_get_shares_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[2,[2,[2,[2,[7,"/",false],[6,"api",false]],[7,"/",false]],[6,"v1",false]],[7,"/",false]],[6,"shares",false]],[7,"/",false]],[3,"id",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// api_v1_get_snippets => /api/v1/snippets(.:format)
  api_v1_get_snippets_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"api",false]],[7,"/",false]],[6,"v1",false]],[7,"/",false]],[6,"snippets",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// api_v1_get_user_tags => /api/v1/user_tags/:type(.:format)
  api_v1_get_user_tags_path: function(_type, options) {
  return Utils.build_path(["type"], ["format"], [2,[2,[2,[2,[2,[2,[2,[2,[7,"/",false],[6,"api",false]],[7,"/",false]],[6,"v1",false]],[7,"/",false]],[6,"user_tags",false]],[7,"/",false]],[3,"type",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// api_v1_my_profile_image => /api/v1/my_profile_image(.:format)
  api_v1_my_profile_image_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"api",false]],[7,"/",false]],[6,"v1",false]],[7,"/",false]],[6,"my_profile_image",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// api_v1_new_report => /api/v1/reports/new/:type(.:format)
  api_v1_new_report_path: function(_type, options) {
  return Utils.build_path(["type"], ["format"], [2,[2,[2,[2,[2,[2,[2,[2,[2,[2,[7,"/",false],[6,"api",false]],[7,"/",false]],[6,"v1",false]],[7,"/",false]],[6,"reports",false]],[7,"/",false]],[6,"new",false]],[7,"/",false]],[3,"type",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// api_v1_reject_invitation => /api/v1/invitations/reject/:id(.:format)
  api_v1_reject_invitation_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[2,[2,[2,[2,[2,[2,[7,"/",false],[6,"api",false]],[7,"/",false]],[6,"v1",false]],[7,"/",false]],[6,"invitations",false]],[7,"/",false]],[6,"reject",false]],[7,"/",false]],[3,"id",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// api_v1_update_password => /api/v1/update_password(.:format)
  api_v1_update_password_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"api",false]],[7,"/",false]],[6,"v1",false]],[7,"/",false]],[6,"update_password",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// api_v1_update_report => /api/v1/reports/:id(.:format)
  api_v1_update_report_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[2,[2,[2,[2,[7,"/",false],[6,"api",false]],[7,"/",false]],[6,"v1",false]],[7,"/",false]],[6,"reports",false]],[7,"/",false]],[3,"id",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// api_v1_update_settings => /api/v1/settings/:id(.:format)
  api_v1_update_settings_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[2,[2,[2,[2,[7,"/",false],[6,"api",false]],[7,"/",false]],[6,"v1",false]],[7,"/",false]],[6,"settings",false]],[7,"/",false]],[3,"id",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// api_v1_update_share => /api/v1/shares/:id(.:format)
  api_v1_update_share_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[2,[2,[2,[2,[7,"/",false],[6,"api",false]],[7,"/",false]],[6,"v1",false]],[7,"/",false]],[6,"shares",false]],[7,"/",false]],[3,"id",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// api_v1_update_snippet => /api/v1/snippets/:id(.:format)
  api_v1_update_snippet_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[2,[2,[2,[2,[7,"/",false],[6,"api",false]],[7,"/",false]],[6,"v1",false]],[7,"/",false]],[6,"snippets",false]],[7,"/",false]],[3,"id",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// api_v1_upload_profile_image => /api/v1/upload_profile_image(.:format)
  api_v1_upload_profile_image_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"api",false]],[7,"/",false]],[6,"v1",false]],[7,"/",false]],[6,"upload_profile_image",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// api_v1_upload_redactor_image => /api/v1/upload_redactor_image(.:format)
  api_v1_upload_redactor_image_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"api",false]],[7,"/",false]],[6,"v1",false]],[7,"/",false]],[6,"upload_redactor_image",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// create_forgot_password_request => /forgot_password(.:format)
  create_forgot_password_request_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[7,"/",false],[6,"forgot_password",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// create_message => /message(.:format)
  create_message_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[7,"/",false],[6,"message",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// create_registration => /register(.:format)
  create_registration_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[7,"/",false],[6,"register",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// dashboard => /dashboard(.:format)
  dashboard_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[7,"/",false],[6,"dashboard",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// edit_report => /reports/edit/:id(.:format)
  edit_report_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"reports",false]],[7,"/",false]],[6,"edit",false]],[7,"/",false]],[3,"id",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// export_report => /export/:file_format/:id(.:format)
  export_report_path: function(_file_format, _id, options) {
  return Utils.build_path(["file_format","id"], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"export",false]],[7,"/",false]],[3,"file_format",false]],[7,"/",false]],[3,"id",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// forgot_password => /forgot_password(.:format)
  forgot_password_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[7,"/",false],[6,"forgot_password",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// login => /login(.:format)
  login_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[7,"/",false],[6,"login",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// logout => /logout(.:format)
  logout_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[7,"/",false],[6,"logout",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// message => /contact(.:format)
  message_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[7,"/",false],[6,"contact",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// my_account => /my_account(.:format)
  my_account_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[7,"/",false],[6,"my_account",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// new_report => /reports/new/:type(.:format)
  new_report_path: function(_type, options) {
  return Utils.build_path(["type"], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"reports",false]],[7,"/",false]],[6,"new",false]],[7,"/",false]],[3,"type",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// password_reset => /password_reset/:token(.:format)
  password_reset_path: function(_token, options) {
  return Utils.build_path(["token"], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"password_reset",false]],[7,"/",false]],[3,"token",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// register => /register(.:format)
  register_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[7,"/",false],[6,"register",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// root => /
  root_path: function(options) {
  return Utils.build_path([], [], [7,"/",false], arguments);
  },
// validate_account => /validate_account/:token(.:format)
  validate_account_path: function(_token, options) {
  return Utils.build_path(["token"], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"validate_account",false]],[7,"/",false]],[3,"token",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  }}
;

  window.ReportIt.routes.options = defaults;

}).call(this);
